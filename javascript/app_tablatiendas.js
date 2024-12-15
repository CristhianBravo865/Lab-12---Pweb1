document.addEventListener("DOMContentLoaded", function () {
    try {
        validarSesion("propietario"); // Validar sesión como propietario

        // Código para manejar la tabla de tiendas
        const tableBody = document.querySelector("#tiendas-table tbody");

        // Cargar tiendas desde el servidor
        fetch("/cgi-bin/tablatiendas.pl")
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Error al cargar los datos del servidor");
                }
                return response.json();
            })
            .then((data) => renderTable(data))
            .catch((err) => {
                console.error("Error al cargar tiendas:", err);
                alert("Hubo un problema al cargar las tiendas.");
            });

        // Renderizar tabla
        function renderTable(tiendas) {
            if (tiendas.length === 0) {
                const row = document.createElement("tr");
                row.innerHTML = `<td colspan="3">No hay tiendas disponibles</td>`;
                tableBody.appendChild(row);
                return;
            }

            tiendas.forEach((tienda) => {
                const row = document.createElement("tr");
                row.innerHTML = `
                    <td>${tienda.id}</td>
                    <td>${tienda.nombre}</td>
                    <td>${tienda.ruc}</td>
                `;
                tableBody.appendChild(row);
            });
        }
    } catch (error) {
        console.error(error.message);
    }
});
