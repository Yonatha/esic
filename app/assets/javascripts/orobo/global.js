    
    $('.collapse').collapse()

    $('select#situacao').on('change',function(){
        $('#btn_exportar_csv').attr('href', $('#btn_exportar_csv').attr('href') + '&situacao='+$(this).val())
        $('#btn_exportar_txt').attr('href', $('#btn_exportar_txt').attr('href') + '&situacao='+$(this).val())
    })

    $('select#tipo').on('change',function(){
        $('#btn_exportar_csv').attr('href', $('#btn_exportar_csv').attr('href') + '&tipo='+$(this).val())
        $('#btn_exportar_txt').attr('href', $('#btn_exportar_txt').attr('href') + '&tipo='+$(this).val())
    })

    $('select#modalidade').on('change',function(){
        $('#btn_exportar_csv').attr('href', $('#btn_exportar_csv').attr('href') + '&modalidade='+$(this).val())
        $('#btn_exportar_txt').attr('href', $('#btn_exportar_txt').attr('href') + '&modalidade='+$(this).val())
    })
