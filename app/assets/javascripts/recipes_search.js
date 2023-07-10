document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('#search-form');
    const resultsDiv = document.querySelector('#search-results');

    form.addEventListener('submit', function(event) {
        event.preventDefault();

        const query = form.querySelector('#query').value;

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

        if (recipes.length === 0) {
        let p = document.createElement('p');
        p.textContent = 'No recipes found.';
        contenedor.appendChild(p);
        } else {
        let ul = document.createElement('ul');

        for (let i = 0; i < recipes.length; i++) {
            let recipe = recipes[i];
            let li = document.createElement('li');
            let link = document.createElement('a');
            link.href = '/recipes/' + recipe.id;
            link.textContent = recipe.name;
            li.appendChild(link);
            ul.appendChild(li);
        }

        contenedor.appendChild(ul);
        }
    }
});