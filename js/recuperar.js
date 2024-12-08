document.addEventListener("DOMContentLoaded", function() {
    const showPopupBtn = document.querySelector(".login-btn");
    const formPopup = document.querySelector(".form-popup");
    const hidePopupBtn = formPopup.querySelector(".close-btn");
    const correoInput = document.querySelector("input[name='nombreC']");
    const pregunta1Input = document.querySelector("input[name='p1']");
    const pregunta2Input = document.querySelector("input[name='p2']");
    const tipoUsuarioRadios = document.querySelectorAll("input[name='tipo_usuario_login']"); // Obtener todos los radios

    showPopupBtn.addEventListener("click", function(event) {
        event.preventDefault();

        const correo = correoInput.value;
        const pregunta1 = pregunta1Input.value;
        const pregunta2 = pregunta2Input.value;
        let tipoUsuario = '';

        tipoUsuarioRadios.forEach(function(radio) {
            if (radio.checked) {
                tipoUsuario = radio.value;
            }
            console.log("TIPO : ", tipoUsuario);
        });

        if (correo.trim() === '' || pregunta1.trim() === '' || pregunta2.trim() === '') {
            alert("Por favor complete todos los campos.");
            return;
        }

        fetch('cgi-bin/recuperar.pl', {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                correo: correo,
                pregunta1: pregunta1,
                pregunta2: pregunta2,
                tipoUsuario: tipoUsuario
            })
        })
        .then(response => {
            if (!response.ok) {
                throw new Error("Error en la solicitud al servidor.");
            }
            return response.json();
        })
        
        .then(data => {
            if (data.valido) {
                console.log("CONSULTA EXITOSA: ", data);
                const showPopupBtn = document.querySelector(".login-btn");
                const formPopup = document.querySelector(".form-popup");
                const hidePopupBtn = formPopup.querySelector(".close-btn");
                const signupLoginLink = formPopup.querySelectorAll(".bottom-link a");
                //animacion popup
                showPopupBtn.addEventListener("click", () => {
                document.body.classList.toggle("show-popup");
                });

                //oculta animacion 
                //hidePopupBtn.addEventListener("click", () => showPopupBtn.click());
            
                // Mostrar ventana emergente para cambiar la contraseña
                const newPasswordInput = document.getElementById("password1R");
                const confirmPasswordInput = document.getElementById("password2R");
                
                // Agregar evento para el envío del formulario de cambio de contraseña
                formPopup.addEventListener("submit", function(event) {

                    event.preventDefault();
            
                    const newPassword = newPasswordInput.value;
                    const confirmPassword = confirmPasswordInput.value;
            
                    if (newPassword.trim() === '' || confirmPassword.trim() === '') {
                        alert("Por favor complete todos los campos.");
                        return;
                    }
            
                    if (newPassword !== confirmPassword) {
                        alert("Las contraseñas no coinciden.");
                        return;
                    }

                    if (newPassword.length > 30) {
                        alert("Las contraseñas es demasiado larga.");
                        return;
                    }
            
                    // Realizar la solicitud para cambiar la contraseña
                    fetch('cgi-bin/cambiar_contrasena.pl', {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json"
                        },
                        body: JSON.stringify({
                            tipoUsuario: tipoUsuario,
                            correo: correo,
                            nuevaContrasena: newPassword
                        })
                    })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error("Error en la solicitud al servidor para cambiar la contraseña.");
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.success) {
                            alert("La contraseña se ha cambiado correctamente.");
                        } else {
                            alert("Hubo un error al cambiar la contraseña.");
                        }
                    })
                    .catch(error => {
                        console.error("Error:", error);
                        alert("Hubo un error al procesar la solicitud para cambiar la contraseña.");
                    });
                });
            } else {
                alert("Los datos ingresados no son válidos.");
            }
        })
        .catch(error => {
            console.error("Error:", error);
            alert("Hubo un error al procesar la solicitud.");
        });
    });

    hidePopupBtn.addEventListener("click", () => showPopupBtn.click());
});
//