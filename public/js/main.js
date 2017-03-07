function row(str){
	event.preventDefault();
	var ref = $(str).attr('href');
	$('body,html').animate({
		scrollTop: $(ref).offset().top
	})
}

function segundosabor(){
	$('#cart_sabor2').empty();
	$('.segundo-sabor').toggleClass('hidden');
}

function loja(str){
    var r = confirm('Este cardápio não corresponde à sua unidade. Deseja ser direcionado para outro cardápio?');

    if(r == true){
        location.href = str;
    }
}

function bebeMenos(str){
	var qtd = parseInt($(str).parent().children('i').text());

	if (qtd > 0){
		var name = $(str).parent().attr('data-name');
		var id = $(str).parent().attr('data-id');
		var price = $(str).parent().attr('data-price');
		var url = $(str).parent().attr('data-url');
		var nova = qtd - 1
		var completo = url + '/' + nova

		$.ajax({
			url: completo,
			method: 'GET',
			dataType: 'JSON'
		}).done(function(data){
			$(str).parent().children('i').text(qtd - 1);
			console.log(data);
		}).fail(function(data, status){
			if(data.status == 200){
				$(str).parent().children('i').text(qtd - 1);
			}else{
				alert('Você precisa estar logado para adicionar bebidas!');
				console.log(data.status);
				console.log(data);
				console.log(status);
			}
		});
	}
}

function bebeMais(str){
	var qtd = parseInt($(str).parent().children('i').text());
	var name = $(str).parent().attr('data-name');
	var id = $(str).parent().attr('data-id');
	var price = $(str).parent().attr('data-price');
	var url = $(str).parent().attr('data-url');
	var nova = qtd + 1
	var completo = url + '/' + nova

	$.ajax({
		url: completo,
		method: 'GET',
		dataType: 'JSON'
	}).done(function(data){
		$(str).parent().children('i').text(qtd + 1);
		console.log(data);
	}).fail(function(data, status){
		if(data.status == 200){
			$(str).parent().children('i').text(qtd + 1);
		}else{
			alert('Você precisa estar logado para adicionar bebidas!');
			console.log(data.status);
			console.log(data);
			console.log(status);
		}
	});
}

$(document).ready(function(){
    
    $('.combo > div').mouseenter(function(){
        $(this).children('div').css('display', 'flex').hide().slideDown();
    });
    
    $('.combo > div').mouseleave(function(){
        $(this).children('div').slideUp();
    });
    
});