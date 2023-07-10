document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('#search-form');
    const resultsDiv = document.querySelector('#search-results');

    form.addEventListener('submit', function(event) {
        event.preventDefault();

        const query = form.querySelector('#query').value;
        form.querySelector('#query').value = '';

        const authenticityToken = document.querySelector('meta[name="csrf-token"]').content;

        const request = new XMLHttpRequest();
        request.open('POST', `/search?query=${encodeURIComponent(query)}`);
        request.setRequestHeader('X-CSRF-Token', authenticityToken);
        request.onload = function() {
        if (request.status === 200) {
            const response = JSON.parse(request.responseText);
            displaySearch(response.recipes);
        }
        };
        request.send();
    });

    function displaySearch(recipes) {
        let contenedor = document.getElementById('search-results');
        contenedor.innerHTML = '';
        contenedor.classList.add('mt-4')

        if (recipes.length === 0) {
            let p = document.createElement('p');
            p.classList.add('text-center')
            p.textContent = 'No recipes found.';
            contenedor.appendChild(p);
        } else {
            let div = document.createElement('div')
            div.classList.add('row');

            let ul = document.createElement('ul');

            for (let i = 0; i < recipes.length; i++) {
                let recipe = recipes[i];
                let col = document.createElement('div');
                col.classList.add('col-md-4', 'mb-4', 'text-center');
            
                let link = document.createElement('a');
                link.classList.add('card');
            
                let cardBody = document.createElement('div');
                cardBody.classList.add('card-body');
            
                link.href = '/recipes/' + recipe.id;
                cardBody.textContent = recipe.name;
            
                link.appendChild(cardBody);
                col.appendChild(link);
                div.appendChild(col);
            }
        
            contenedor.appendChild(div);
        }
    }
});