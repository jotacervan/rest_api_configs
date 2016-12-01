$(document).ready(function(){
    
    $('.combo > div').mouseenter(function(){
        $(this).children('div').css('display', 'flex').hide().slideDown();
    });
    
    $('.combo > div').mouseleave(function(){
        $(this).children('div').slideUp();
    });
    
});