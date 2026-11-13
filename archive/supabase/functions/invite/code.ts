// Davet kodu: 6 karakter. 0/O/1/I/L gibi karışanlar alfabede yok; migration
// içindeki `invites.code` kısıtıyla aynı küme.

export const codeAlphabet = "ABCDEFGHJKMNPQRSTUVWXYZ23456789";
export const codeLength = 6;

export function generateCode(): string {
  // 256 % 31 != 0; sapma olmasın diye taşan baytlar atılır.
  const limit = 256 - (256 % codeAlphabet.length);
  let code = "";
  while (code.length < codeLength) {
    for (const byte of crypto.getRandomValues(new Uint8Array(16))) {
      if (byte < limit && code.length < codeLength) {
        code += codeAlphabet[byte % codeAlphabet.length];
      }
    }
  }
  return code;
}

/// Kullanıcının yazdığı ya da yapıştırdığı kod: boşluk ve tireler atılır,
/// harfler büyütülür.
export function normalizeCode(input: string): string {
  return input.replace(/[\s-]/g, "").toUpperCase();
}

export function isCode(value: string): boolean {
  return value.length === codeLength &&
    [...value].every((c) => codeAlphabet.includes(c));
}

export function isInviteRole(value: unknown): value is
  | "partner"
  | "worker"
  | "viewer" {
  return value === "partner" || value === "worker" || value === "viewer";
}
