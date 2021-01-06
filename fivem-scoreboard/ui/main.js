/*
--[ Scoreboard - edited by szymczakovv ]--
-- Name: Scoreboard Reworked from esx_scoreboard and szymczakovv_scoreboard (first version of scoreboard on github)
-- Author: szymczakovv#1937
-- Date: 06/01/2021
-- Version: 2.0
-- Original: https://github.com/esx-community/esx_scoreboard
*/
window.addEventListener("message", event=>{
    if (event.data.action == "display"){
        var count = 0;

        var array = Object.values(event.data.data);

        var html = 
        `<tr class="details">
            <th>ID</th>
            <th>STEAM</th>
            <th>  DISCORD</th>
            <th>PING</th>
        </tr>`
        $('.main-table').html(html);
        for(let i = 0; i < array.length; i++){
            if(array[i] != null) {
                var html = 
                `<tr>
                    <th>${array[i].id}</th>
                    <th>${array[i].steam}</th>
                    <th class="claude"><img
                    src= ${array[i].avatar}
                    width="22" height="22">${array[i].discord}</th>
                    <th style="color:rgb(0, 209, 0)">${array[i].ping}ms</th>
                </tr>`
                $('.main-table').append(html);
                count++;
            }
        }
        $('.scoreboard-bottom span').html(`Graczy: ${count}/64 | Średni FPS Serwera: ${event.data.fps > 0 ? event.data.fps : "Sprawdzam.."}`);
        $(".scoreboard-wrapper").fadeIn();

    } 
    if (event.data.action == "close") {

        setTimeout(function(){ $(".scoreboard-wrapper").fadeOut(); }, 200);
    }
})



function GetWidth(level){
    if (level == "high") 
        return "100%";
    else if (level == "medium")
        return "50%";
    else if (level == "low")
        return "30%";
}

 $(document).ready(()=> {
    document.onkeyup = function (data) {
        if (data.which == 33) {

            setTimeout(function(){ $(".scoreboard-wrapper").fadeOut();  }, 200);
            $.post("http://fivem-scoreboard/close",JSON.stringify({}))
        } 
        else if (data.which == 27) {

            setTimeout(function(){ $(".scoreboard-wrapper").fadeOut();  }, 200);
            $.post("http://fivem-scoreboard/close",JSON.stringify({}))
        }
        else if (data.which == 9) {
            $.post("http://fivem-scoreboard/NuiFocus",JSON.stringify({}))
        }
    };
});
