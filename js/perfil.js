document.addEventListener('DOMContentLoaded', function() {
  const http = new XMLHttpRequest();
  http.open('GET', 'cgi-bin/perfil.pl', true);
  http.onreadystatechange = function() {
      if (http.readyState == 4 && http.status == 200) {
          actualizarCampos(http.responseText);
      }
  };
  http.send();
});

function actualizarCampos(datos) {
  var datosObj = JSON.parse(datos);

  document.getElementById('nombreC').value = datosObj[0];
  document.getElementById('dni').value = datosObj[1];
  document.getElementById('celular').value = datosObj[2];
  document.getElementById('tipoUsuario').value = datosObj[3];
  document.getElementById('nombreUsuario').value = datosObj[4];
  document.getElementById('correo').value = datosObj[5];
  document.getElementById('idTarjeta').value = datosObj[6];
}

//Cargar credito
document.addEventListener("DOMContentLoaded", function() {
    fetch('cgi-bin/get_datos.pl')
        .then(response => {
            if (!response.ok) {
                throw new Error(`Error en la solicitud: ${response.statusText}`);
            }
            return response.json();
        })
        .then(data => {
            console.log('Datos recibidos:', data);
            const creditoUsuario = document.getElementById('credito-nav');

            if (creditoUsuario && data && data.credito !== undefined) {
                creditoUsuario.textContent = `s/.${data.credito}`;
            } else {
                console.error('Error: Datos no disponibles en la respuesta.');
            }
        })
        .catch(error => console.error('Error al obtener los datos del usuario:', error));
});

//Funcionalidad de interaccion SALIR
document.addEventListener("DOMContentLoaded", function() {
    document.getElementById("salir-btn").addEventListener("click", function() {
        fetch("cgi-bin/salir.pl", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
        })
        .then(response => {
            if (!response.ok) {
                throw new Error("Error al intentar borrar las cookies");
            }
            console.log("Cookies borradas correctamente");
            window.location.href = "index.html";
        })
        .catch(error => {
            console.error(error);
        });
    });
});