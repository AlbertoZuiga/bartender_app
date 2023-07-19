function rate_recipe(id, rate) {
    
    const authenticityToken = document.querySelector('meta[name="csrf-token"]').content;

    const xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
            const response = JSON.parse(xhr.responseText);
            displayRating(response.rating)
        } else {
            console.error('Error:', xhr.status);
        }
        }
    };

    xhr.open('POST', '/recipes/'+id+'/rate', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('X-CSRF-Token', authenticityToken);
    xhr.send(JSON.stringify({ rating: rate }));
};

function displayRating(rating) {
    const ratingStar = document.getElementById('rating-star');
    const stars = ratingStar.querySelectorAll('span');
    
    for (let i = 0; i < 5; i++) {
        if (i + 1 <= rating) {
            stars[i].classList.add('yellow');
        } else {
            stars[i].classList.remove('yellow');
        }
    }
    
    const ratingText = document.getElementById('rating-recipe');
    ratingText.innerHTML = rating
};
