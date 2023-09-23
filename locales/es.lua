local Translations = {
    label1 = 'Comprar un billete',
    label2 = 'Viaje a Guarma',
    label3 = 'Viaje a St Denis',
    label4 = ' por billete',
    label5 = 'Cuántos',
    label6 = 'Rumbo al Puerto de Guarma',
    label7 = 'Tu barco está navegando',
    label8 = 'Que tengas un buen viaje...',
    label9 = '¡no tienes billete!',
    label10 = 'Rumbo al puerto de Saint Denis',
    label11 = 'billete de barco comprado por $',
    label12 = '¡No tienes suficiente efectivo para hacer eso!',
}

if GetConvar('rsg_locale', 'en') == 'es' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end