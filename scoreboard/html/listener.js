/*scoreboard powered by: https://szymczakovv.pl
Nazwa: scoreboard
Autor: Szymczakovv#0001
Data: 05 / 06 / 2020
Wersja: 0.01*/

$(function ()
{
    window.addEventListener('message', function(event)
    {
        var item = event.data;
        var buf = $('#wrap');
        buf.find('table').append("<tr class=\"heading\"><th>ID</th><th>Nick Steam</th><th>         </th>");
        if (item.meta && item.meta == 'close')
        {
            document.getElementById("ptbl").innerHTML = "";
            $('#wrap').hide();
            return;
        }
        
        buf.find('table').append(item.text);
        $('#wrap').show();
    }, false);
});