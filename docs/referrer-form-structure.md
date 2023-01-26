# Referer form structure

The form is made up of:

- **Eligibility screener** - Filters out ineligible referrals
- **Main Referral form** - capture the referral and send to the team

## Elegibility screener

This takes you through the following steps:

```
ReferralTypeController#new
IsTeacherController#new
TeachingInEnglandController#new
SeriousMisconductController#new
```

Each form shown on `new` posts to `create` on the same controller then redirects to the next step.

Once done you're redirected to the final page for this section:

```
PagesController#you_should_know
```

# Main referral form

If you're eligible you'll be sent to the referral controller where a new referral object is saved. All further actions are performed on the referral object. You're then sent to the top level form for the referral at `#edit`:

```
ReferralsController#new
ReferralsController#edit
```

Each section of the form then has its own controller.

So for instance for the your details section the form steps through each of these, saving the referral object as it goes:

```
Referrals::ReferrerNameController#edit
Referrals::ReferrerJobTitleController#edit
Referrals::ReferrerPhoneController#edit
```

After which we show them all the steps and confirm here:

```
Referrals::ReferrersController#show
```

### Form objects

Each of the steps above has it's own form object so for instance [app/controllers/referrals/referrer_phone_controller.rb](../app/controllers/referrals/referrer_phone_controller.rb) uses [app/forms/referrer_phone_form.rb](../app/forms/referrer_phone_form.rb)

This allows us to keep the validation on the form object and thus build the model up section by section.

Each form object has reference to the referrer db object and uses that to save itself.
