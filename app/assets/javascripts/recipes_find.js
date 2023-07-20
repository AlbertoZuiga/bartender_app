function findRecipes(id) {
    if (document.querySelector('#ingredient-checkbox-'+id).checked){
        check = true
    } else{
        check = false
    };
    
    let ingredient = {ingredient_id: id, checked: check};
    
    const authenticityToken = document.querySelector('meta[name="csrf-token"]').content;
    
    const xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
            const response = JSON.parse(xhr.responseText);
        } else {
            console.error('Error:', xhr.status);
        }
        }
    };
    
    xhr.open('POST', '/recipes/find', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('X-CSRF-Token', authenticityToken);
    xhr.send(JSON.stringify({ ingredient }));
}