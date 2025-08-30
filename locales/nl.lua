local Translations = {
    info = {
        ['open_uber_menu'] = "Open Uber Menu",
        ['uber_job'] = "Uber Job",
        ['no_ubers_online'] = "Er zijn geen ubers online.",
        ['wrong_vehicle'] = "U beschikt niet over een voertuig uit de categorie %{category} om deze taak uit te voeren.",
        ['can_not_call_your_self'] = "Je kunt jezelf niet mailen voor een uber...",
        ['click_to_send_sms'] = "klik om sms te zenden",
        ['not_in_vehicle'] = "U moet in een voertuig zitten voor Uber te rijden.",
        ['mailsend'] = "Mail is verzonden",
        ['mailnotsend'] = "Mail is niet verzonden",
        ['uber'] = "Uber Bestuurder %{fullname}",
        ['close'] = "Sluiten",
        ['caller_not_online'] = "Beller is niet online",
        ['uber_not_online'] = "Uber bestuurder is niet online",
        ['received_mail'] = "Mail ontvangen, Ik ben onderweg!",
    },
    main = {
        ['sender'] = "%{fullname}",
        ['subject'] = "Uber Nodig",
        ['message'] = "Hallo, ik heb een uber nodig, hier is mijn telefoonnummer: %{phone}",
    },
    onduty = {
        ['enable'] = "In Dienst",
        ['disable'] = "Uit Dienst",
    }
}

if GetConvar('qb_locale', 'en') == 'nl' then
    Lang = Locale:new({phrases = Translations, warnOnMissing = true, fallbackLang = Lang})
end