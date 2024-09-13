function arrayRemove(arr: any[], value: any) { 

    return arr.filter(function(ele){ 
        return ele != value; 
    });
}

// Function to get a random item from an array
function getRandomItem<T>(items: T[]): T {
    return items[Math.floor(Math.random() * items.length)];
}