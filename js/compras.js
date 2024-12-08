document.addEventListener("DOMContentLoaded", function() {
    var pagarButton = document.getElementById("pagar");
    pagarButton.addEventListener("click", function() {
        var valorBoton = pagarButton.value;
        
        var partes = valorBoton.split(": ");
        var total = parseFloat(partes[1]);
        var ids = partes[2].split(", ");
        
        console.log("Total:", total);
        console.log("IDs:", ids);
        
        fetch("cgi-bin/pagar.pl", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                total: total,
                ids: ids
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                alert("Error: " + data.error); // Muestra la alerta si hay un error
            } else {
                const creditoA = document.getElementById("credito-nav");
                creditoA.textContent = "s/." + data.saldoF;
                console.log("costoFinal:", total);
                console.log("credito actualizado a:", data.saldoF);
                alert("Compra realizada con éxito");
            }
        })
        .catch(error => {
            console.error("Error al realizar la solicitud de compra:", error);
            alert("Error: " + error); // Muestra la alerta si hay un error de red u otro error
        });
    });
});
