
$(document).ready(function(){
    var myApp;
    myApp = myApp || (function () {
        var pleaseWaitDiv = $('<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false"><div class="modal-header"><h1>Processing...</h1></div><div class="modal-body"><div class="progress progress-striped active"><div class="bar" style="width: 100%;"></div></div></div></div>');
        return {
            showPleaseWait: function() {
                pleaseWaitDiv.modal();
            },
            hidePleaseWait: function () {
                pleaseWaitDiv.modal('hide');
            }
        };
    })();
});

$('#share_button').click(function(e){
    e.preventDefault();
    FB.ui(
        {
            method: 'feed',
            name: user_name +' pense que le match '+ match_name+' se terminera sur le score de '+prono_score,
            link: url,
            picture: image_url,
            caption: 'Toi aussi, défend ton pronostic et défis tes amis sur FootiBon',
            description: 'FootiBon est un jeu fun et gratuit permettant de s\'amuser entre amis en pronostiquant les résultats des matchs du mondial 2014. Rdv sur http://www.footibon.com',
            message : prono_score+', voici mon pronostic pour le match '+ match_name + ". Qu'en penses-tu?"
        });
});







