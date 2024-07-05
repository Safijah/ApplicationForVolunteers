using RadVolontera.Models.Payment;
using RadVolontera.Services.Interfaces;
using Stripe;

namespace RadVolontera.Services.Services
{
    public class PaymentTicketService : IPaymentTicketService
    {
        public async Task<bool> Pay(PaymentTicket model)
        {
            try
            {
                StripeConfiguration.ApiKey = "sk_test_51PXjj82Lmi8PKb51pFaHhOwalY8Z96iPU1L4q31ZJoyaa0XVuxgnX4W2mI9NOqTvLFvEv3tZJbPeLDLIiV3uBIzv00rh9GXmfs";
                var optionsToken = new TokenCreateOptions
                {
                    Card = new TokenCardOptions
                    {
                        Number = model.CardNumber,
                        ExpMonth = model.Month,
                        ExpYear = model.Year,
                        Cvc = model.Cvc,
                        Name = model.CardHolderName
                    }
                };
                ////var serviceToken = new Stripe.TokenService();
                ////Token stripeToken = await serviceToken.CreateAsync(optionsToken);
                var options = new ChargeCreateOptions
                {
                    Amount = (model.TotalPrice * 100),
                    Currency = "bam",
                    Description = "Rad volontera karta",
                    Source = "tok_mastercard"
                };
                var service = new ChargeService();
                Charge charge = await service.CreateAsync(options);
                if (charge.Paid)
                {

                    return true;
                }
                else
                    return false;

            }
            catch (Exception ex)
            {

                throw ex;
            }

        }
    }
}
