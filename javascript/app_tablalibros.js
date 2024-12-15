document.addEventListener("DOMContentLoaded", function () {
    const tableBody = document.querySelector("#libros-table tbody");

    // Cargar libros desde el servidor
    fetch("/cgi-bin/tablalibros.pl")
        .then((response) => {
            if (!response.ok) {
                throw new Error("Error al cargar los datos del servidor");
            }
            return response.json();
        })
        .then((data) => {
            renderTable(data);
        })
        .catch((err) => {
            console.error("Error al cargar libros:", err);
            alert("Hubo un problema al cargar los libros. Inténtalo nuevamente más tarde.");
        });

    // Renderizar los libros en la tabla
    function renderTable(libros) {
        if (libros.length === 0) {
            const row = document.createElement("tr");
            row.innerHTML = `<td colspan="5">No hay libros disponibles</td>`;
            tableBody.appendChild(row);
            return;
        }

        libros.forEach((libro) => {
            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${libro.id}</td>
                <td>${libro.nombre}</td>
                <td>${libro.descripcion}</td>
                <td><img src="/images/${libro.imagen}" alt="${libro.nombre}" width="50"></td>
                <td>${libro.precio}</td>
            `;
            tableBody.appendChild(row);
        });
    }
});
