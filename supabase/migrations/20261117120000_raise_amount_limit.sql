-- Tutar üst sınırı 1 milyardan 1 trilyona çıkar. Riyal (IRR) gibi düşük
-- değerli para birimlerinde tek bir bal satışı 1 milyarı aşıyordu.
-- numeric(12, 2) en çok 9.999.999.999,99 tutar; 10^12 için numeric(18, 2).
-- Yerelde tutar `real` (double): 10^12'ye kadar kuruşu kuruşuna saklar.
-- Sınır yalnız gevşer; eski istemcilerin gönderdiği her kayıt geçerli kalır.

alter table public.transactions
  drop constraint transactions_amount_check,
  alter column amount type numeric(18, 2),
  add constraint transactions_amount_check
    check (amount > 0 and amount <= 1000000000000);

alter table public.customer_payments
  drop constraint customer_payments_amount_check,
  alter column amount type numeric(18, 2),
  add constraint customer_payments_amount_check
    check (amount > 0 and amount <= 1000000000000);
