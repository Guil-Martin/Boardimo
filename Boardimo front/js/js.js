// Scan
var scanInput = document.getElementById("scanInput");
var btnScan = document.getElementById("scan");
var result = document.getElementById("results")
btnScan.addEventListener("click", function(e) {

    fetch('http://localhost:7373/api_scan', {
        method: 'POST',
        // mode: 'no-cors',
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({link: scanInput.value}),
    })
    .then(response => response.json())
    .then(data => {
        console.log(data)

        result.innerHTML = `
            <div class="flex-none w-48 relative">
                <img src="${data["house"]["img"]}" alt="" class="absolute inset-0 w-full h-full object-cover" />
            </div>
            <form class="flex-auto p-6">
                <div class="flex flex-wrap">
                    <h1 class="flex-auto text-xl font-semibold">
                        ${data["house"]["name"]}
                    </h1>
                    <div class="text-xl font-semibold text-gray-500">
                        ${data["house"]["price"]}
                    </div>
                </div>

                <div class="divide-y divide-fuchsia-300">
                    <div>
                        <span class="badge bg-primary">${data["house"]["surface"]}</span>   
                        <span class="badge bg-primary">${data["house"]["year"]}</span> 
                        <span class="badge bg-d">${data["house"]["energetics"]}</span>
                    </div>
                    <br>
                    <div class="bottom-divide">
                        Prix par m² <span class="price">${data["stats"]["price_sqm"]}</span>
                    </div>

                </div>
            </form>
            `;

        // update content
    })
    .catch(error => {
        console.error('Error:', error);
    });

});

var linksEnable = document.getElementById("linksEnable"); 
var linksContainer = document.getElementsByClassName("links")[0]; 
linksEnable.addEventListener("click", function(e) {

    console.log(e.currentTarget);
    e.currentTarget.disabled = true;

    fetch('http://localhost:7373/api_links')
    .then(response => response.json())
    .then(data => {

        linksContainer.innerHTML = ""

        console.log(data)

        for (let index = 0; index < data["links"].length; index++) {
            linksContainer.innerHTML +=     
            `
            <button value="${data["links"][index]}" class="linkBtn">M</button>
            `
        }

        var buttons = linksContainer.querySelectorAll('.linkBtn');
        for (var i = 0; i < buttons.length; i++) {
            buttons[i].addEventListener('click', function(ebtn) {
                scanInput.value = ebtn.currentTarget.value;
                btnScan.click();
            });
        }

    })
    .catch((error) => {
        console.error('Error:', error);
    });

});