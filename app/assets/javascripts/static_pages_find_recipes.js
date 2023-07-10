function findRecipes() {
    const checkboxes = document.querySelectorAll('.item-checkbox');
    let ingredientsId = [];
    
    checkboxes.forEach((checkbox) => {
        if (checkbox.checked) {
        const itemId = parseFloat(checkbox.getAttribute('data-id'));
        ingredientsId.push(itemId);
        }
    });
    
    const authenticityToken = document.querySelector('meta[name="csrf-token"]').content;
    
    const xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
            const response = JSON.parse(xhr.responseText);
            displayList(response.recipes);
        } else {
            console.error('Error:', xhr.status);
        }
        }
    };
    
    xhr.open('POST', '/static_pages/find_recipes', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('X-CSRF-Token', authenticityToken);
    xhr.send(JSON.stringify({ ingredientsId }));
    }
    
    function displayList(recipes) {
    let contenedor = document.getElementById('make_recipes');
    contenedor.innerHTML = '';
    let ul = document.createElement('ul');
    
    for (let i = 0; i < recipes.length; i++) {
        let recipe = recipes[i];
        let li = document.createElement('li');
        let link = document.createElement('a');
        link.href = recipe.link;
        link.textContent = recipe.name;
        li.appendChild(link);
        ul.appendChild(li);
    }
    contenedor.appendChild(ul);
    }