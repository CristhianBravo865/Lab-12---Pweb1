// recuperar_contraseña.js
function recuperarContraseña() {
    const email = document.getElementById('email').value;

    // Realizar una solicitud al servidor para recuperar la contraseña
    fetch('', {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ email: email })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert("Se ha enviado un correo con instrucciones para recuperar la contraseña.");
        } else {
            alert("No se pudo procesar la solicitud. Verifica tu correo electrónico e inténtalo de nuevo.");
        }
    })
    .catch(error => {
        console.error("Error al procesar la solicitud:", error);
    });
}
