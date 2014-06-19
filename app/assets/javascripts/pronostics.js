$('#share_button').click(function(e){
    e.preventDefault();
    FB.ui(
        {
            display: 'touch',
            method: 'feed',
            name: user_name +' pense que le match '+ match_name+' se terminera sur le score de '+prono_score,
            link: url,
            picture: image_url,
            caption: 'Toi aussi, défis tes amis et donne ton pronostic sur FootiBon',
            description: 'FootiBon est un jeu fun et gratuit permettant de défier ses amis en pronostiquant les résultats des matchs du mondiale 2014. Rdv sur http://www.footibon.com',
            message : prono_score+', voici mon pronostic pour le match '+ match_name + ". Qu'en penses-tu?"
        });
});

