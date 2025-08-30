local Translations = {
    info = {
        ['open_uber_menu'] = "Open Uber Menu",
        ['uber_job'] = "Uber Job",
        ['no_ubers_online'] = "There are no ubers online.",
        ['wrong_vehicle'] = "You don't have a category %{category} vehicle to do this job.",
        ['can_not_call_your_self'] = "You can't email yourself for an Uber...",
        ['click_to_send_sms'] = "Click to send sms",
        ['not_in_vehicle'] = "U moet in een voertuig zitten voor Uber te rijden.",
        ['mailsend'] = "Mail is sended",
        ['mailnotsend'] = "Mail not send",
        ['uber'] = "Uber Driver %{fullname}",
        ['close'] = "Close",
        ['caller_not_online'] = "Caller is not online",
        ['uber_not_online'] = "Uber driver is not online",
        ['received_mail'] = "Received mail, I'm on my way!",
    },
    main = {
        ['sender'] = "%{fullname}",
        ['subject'] = "Uber Needed",
        ['message'] = "Hello, I need an uber, here is my phone number: %{phone}",
    },
    onduty = {
        ['enable'] = "Enable Duty",
        ['disable'] = "Disable Duty",
    }
}

if GetConvar('qb_locale', 'en') == 'en' then
    Lang = Locale:new({phrases = Translations, warnOnMissing = true, fallbackLang = Lang})
end