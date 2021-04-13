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


// var content = document.getElementById("test");
// var btnScan = document.getElementById("scan");
// btnScan.addEventListener("click", function(e) {

//     fetch('http://localhost:7373/api_index')
//     .then(response => response.json())
//     .then(data => {

//         console.log(data["houses"])

//         for (let index = 0; index < data["houses"].length; index++) {
//             content.innerHTML += "<p>"+ data["houses"][index]["link"] + "</p>"      
            
            







            
//         }

//         // // List of available products in an option select
//         // for (let [key, value] of Object.entries(data.product_list)) {
//         //     console.log(`${key}: ${value}`);
//         //     select.innerHTML += "<option value="+ key +">"+key+"</option>"
//         // }
//         // // CREATE FRUIT CARDS

//         // // Displays list of products in current cart
//         // list.innerHTML = null;
//         // for (let [key, value] of Object.entries(data.cart_list)) {
//         //     list.innerHTML += "<p value="+ value +">"+ value + "</p>"
//         // }
//         // total.innerHTML = data.cart_total + " €"

//         // let btns = document.querySelectorAll('.fruitCard');
//         // console.log(btns)
//         // // adding the event listener by looping
//         // btns.forEach(el => {
//         //     console.log(el)
//         //     el.addEventListener('click', (e) => {
//         //         console.log(e.currentTarget.value);
//         //     });
//         // });

//     })
//     .catch((error) => {
//         console.error('Error:', error);
//     });

// });