function enviarFormularioRegistro() {
    var user= document.getElementById('user').value;
    var password = document.getElementById('password').value;
    var type = document.getElementById('type').value;
    var name = document.getElementById('name').value;
    var card_number = document.getElementById('card_number').value;
    var card_expire = document.getElementById('card_expire').value;
    var card_code = document.getElementById('card_code').value;

    fetch('./cgi-bin/registro.pl', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            nombreC: nombreC,
            dni: dni,
            celular: celular,
            nameSesionUsuario: nameSesionUsuario,
            password: password,
            tipoUsusario: tipoUsusario,
            usuario: usuario,
            correo: correo,
            numero_tarjeta: numero_tarjeta,
            fecha_caducidad_tarjeta: fecha_caducidad_tarjeta,
            codigo: codigo,
            pregunta1: pregunta1,
            pregunta2: pregunta2,
            
        }),
    })
    .then(response => response.json())
    .then(data => {
        console.log('Respuesta del servidor:', data);
    })
    .catch((error) => {
        console.error('Error en la solicitud:', error);
    });
}
