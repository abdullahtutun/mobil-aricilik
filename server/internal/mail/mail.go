// Package mail sends plain text e-mail from an SMTP account of our own,
// apart from PocketBase's mailer (P5.7). PocketBase's settings hold the
// noreply account (OTP, P4.2); the feedback mail goes out from the feedback
// mailbox, so it needs a second client with its own login.
//
// The client is PocketBase's tools/mailer SMTPClient: the same transport,
// TLS and header handling (CR/LF stripped, non-ASCII Q-encoded) as the
// OTP e-mails.
package mail

import (
	"errors"
	"net/mail"

	"github.com/pocketbase/pocketbase/tools/mailer"
)

// implicitTLSPort is SMTPS: TLS from the first byte. Other ports (587)
// upgrade with STARTTLS when the server offers it.
const implicitTLSPort = 465

// Account is one SMTP login. Password is a secret; never log it.
type Account struct {
	Host     string
	Port     int
	Username string
	Password string
}

// Message is one plain text e-mail. ReplyTo is optional.
type Message struct {
	To      string
	ReplyTo string
	Subject string
	Text    string
}

// Sender sends from one account, as "FromName <Username>".
type Sender struct {
	client mailer.Mailer
	from   mail.Address
}

// New returns a sender for the account.
func New(a Account, fromName string) *Sender {
	return &Sender{
		client: &mailer.SMTPClient{
			Host:       a.Host,
			Port:       a.Port,
			Username:   a.Username,
			Password:   a.Password,
			TLS:        a.Port == implicitTLSPort,
			AuthMethod: mailer.SMTPAuthPlain,
		},
		from: mail.Address{Name: fromName, Address: a.Username},
	}
}

// ErrBadAddress is returned when To or ReplyTo is not one e-mail address.
var ErrBadAddress = errors.New("mail: invalid address")

// Send delivers m. A ReplyTo that is not a single address is an error, so a
// stored value can never add headers or recipients.
func (s *Sender) Send(m Message) error {
	to, err := mail.ParseAddress(m.To)
	if err != nil {
		return ErrBadAddress
	}
	msg := &mailer.Message{
		From:    s.from,
		To:      []mail.Address{*to},
		Subject: m.Subject,
		Text:    m.Text,
	}
	if m.ReplyTo != "" {
		reply, err := mail.ParseAddress(m.ReplyTo)
		if err != nil {
			return ErrBadAddress
		}
		msg.Headers = map[string]string{"Reply-To": reply.Address}
	}
	return s.client.Send(msg)
}
