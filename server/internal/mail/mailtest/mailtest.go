// Package mailtest is an SMTP server for tests: it accepts every message
// on 127.0.0.1 (net/smtp sends PLAIN credentials without TLS only to
// localhost), records the login and the message, and decodes the subject
// and the plain text part.
package mailtest

import (
	"bufio"
	"bytes"
	"encoding/base64"
	"io"
	"mime"
	"mime/multipart"
	"mime/quotedprintable"
	"net"
	"net/mail"
	"strconv"
	"strings"
	"sync"
	"testing"
	"time"
)

// Mail is one received message.
type Mail struct {
	// User and Pass are the AUTH PLAIN login.
	User, Pass string
	// From and To are the envelope (MAIL FROM, RCPT TO).
	From string
	To   []string
	// Header is the message header; Subject is its decoded subject.
	Header  mail.Header
	Subject string
	// Text is the decoded text/plain part.
	Text string
}

// Server is a running fake SMTP server.
type Server struct {
	Host string
	Port int

	ln   net.Listener
	mu   sync.Mutex
	got  []Mail
	errs []error
	wg   sync.WaitGroup
}

// Start runs a server until the test ends.
func Start(t testing.TB) *Server {
	t.Helper()
	ln, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	addr := ln.Addr().(*net.TCPAddr)
	s := &Server{Host: "127.0.0.1", Port: addr.Port, ln: ln}
	s.wg.Add(1)
	go s.accept()
	t.Cleanup(func() {
		_ = ln.Close()
		s.wg.Wait()
		s.mu.Lock()
		defer s.mu.Unlock()
		for _, err := range s.errs {
			t.Errorf("mailtest: %v", err)
		}
	})
	return s
}

// Mails returns the messages received so far.
func (s *Server) Mails() []Mail {
	s.mu.Lock()
	defer s.mu.Unlock()
	return append([]Mail(nil), s.got...)
}

// WaitFor waits up to timeout for n messages and returns what arrived.
func (s *Server) WaitFor(n int, timeout time.Duration) []Mail {
	deadline := time.Now().Add(timeout)
	for {
		got := s.Mails()
		if len(got) >= n || time.Now().After(deadline) {
			return got
		}
		time.Sleep(10 * time.Millisecond)
	}
}

func (s *Server) accept() {
	defer s.wg.Done()
	for {
		conn, err := s.ln.Accept()
		if err != nil {
			return
		}
		s.wg.Add(1)
		go func() {
			defer s.wg.Done()
			defer conn.Close()
			_ = conn.SetDeadline(time.Now().Add(10 * time.Second))
			s.session(conn)
		}()
	}
}

func (s *Server) fail(err error) {
	s.mu.Lock()
	s.errs = append(s.errs, err)
	s.mu.Unlock()
}

func (s *Server) session(conn net.Conn) {
	r := bufio.NewReader(conn)
	reply := func(line string) { _, _ = io.WriteString(conn, line+"\r\n") }
	reply("220 mailtest ready")

	var m Mail
	for {
		line, err := r.ReadString('\n')
		if err != nil {
			return
		}
		line = strings.TrimRight(line, "\r\n")
		verb := strings.ToUpper(strings.SplitN(line, " ", 2)[0])
		switch verb {
		case "EHLO", "HELO":
			reply("250-mailtest")
			reply("250 AUTH PLAIN")
		case "AUTH":
			parts := strings.Fields(line)
			if len(parts) != 3 || strings.ToUpper(parts[1]) != "PLAIN" {
				reply("504 PLAIN only")
				continue
			}
			raw, err := base64.StdEncoding.DecodeString(parts[2])
			fields := bytes.Split(raw, []byte{0})
			if err != nil || len(fields) != 3 {
				reply("501 bad credentials")
				continue
			}
			m.User, m.Pass = string(fields[1]), string(fields[2])
			reply("235 ok")
		case "MAIL":
			m.From = strings.Trim(strings.TrimPrefix(line[len("MAIL FROM:"):], " "), "<>")
			reply("250 ok")
		case "RCPT":
			m.To = append(m.To, strings.Trim(strings.TrimSpace(line[len("RCPT TO:"):]), "<>"))
			reply("250 ok")
		case "DATA":
			reply("354 go on")
			data, err := readData(r)
			if err != nil {
				s.fail(err)
				return
			}
			if err := parse(&m, data); err != nil {
				s.fail(err)
			}
			s.mu.Lock()
			s.got = append(s.got, m)
			s.mu.Unlock()
			m = Mail{User: m.User, Pass: m.Pass}
			reply("250 queued")
		case "RSET", "NOOP":
			reply("250 ok")
		case "QUIT":
			reply("221 bye")
			return
		default:
			reply("502 " + strconv.Quote(verb))
		}
	}
}

// readData reads the DATA section up to the lone dot, undoing dot-stuffing.
func readData(r *bufio.Reader) ([]byte, error) {
	var out bytes.Buffer
	for {
		line, err := r.ReadString('\n')
		if err != nil {
			return nil, err
		}
		if line == ".\r\n" {
			return out.Bytes(), nil
		}
		out.WriteString(strings.TrimPrefix(line, "."))
	}
}

func parse(m *Mail, data []byte) error {
	msg, err := mail.ReadMessage(bytes.NewReader(data))
	if err != nil {
		return err
	}
	m.Header = msg.Header
	dec := new(mime.WordDecoder)
	if m.Subject, err = dec.DecodeHeader(msg.Header.Get("Subject")); err != nil {
		return err
	}
	m.Text, err = plainText(msg.Header.Get("Content-Type"), msg.Header.Get("Content-Transfer-Encoding"), msg.Body)
	return err
}

// plainText finds the text/plain part, one level of multipart deep or two.
func plainText(contentType, encoding string, body io.Reader) (string, error) {
	media, params, err := mime.ParseMediaType(contentType)
	if contentType == "" {
		media, err = "text/plain", nil
	}
	if err != nil {
		return "", err
	}
	if strings.HasPrefix(media, "multipart/") {
		mr := multipart.NewReader(body, params["boundary"])
		for {
			part, err := mr.NextRawPart()
			if err == io.EOF {
				return "", nil
			}
			if err != nil {
				return "", err
			}
			text, err := plainText(part.Header.Get("Content-Type"), part.Header.Get("Content-Transfer-Encoding"), part)
			if err != nil || text != "" {
				return text, err
			}
		}
	}
	if media != "text/plain" {
		return "", nil
	}
	if strings.EqualFold(encoding, "quoted-printable") {
		body = quotedprintable.NewReader(body)
	}
	b, err := io.ReadAll(body)
	return strings.ReplaceAll(string(b), "\r\n", "\n"), err
}
