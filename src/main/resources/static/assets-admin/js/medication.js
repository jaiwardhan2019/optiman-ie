document.addEventListener('DOMContentLoaded', function() {
    const medicineSearch = document.getElementById('medicineSearch');
    const suggestions = document.getElementById('suggestions');
    const selectedMedicines = document.getElementById('selectedMedicines');
    const clearSearch = document.getElementById('clearSearch');
    
    // Sample medicine database (in a real app, this would come from an API)
    const medicineDatabase = [
        "Aspirin",
        "Amoxicillin",
        "Azithromycin",
        "Atorvastatin",
        "Atenolol",
        "Acetaminophen",
        "Advil",
        "Albuterol",
        "Benzonatate",
        "Bactrim",
        "Bupropion",
        "Ciprofloxacin",
        "Citalopram",
        "Clindamycin",
        "Doxycycline",
        "Diazepam",
        "Diclofenac",
        "Fluoxetine",
        "Furosemide",
        "Gabapentin"
    ];
    
    // Search input event listener
    medicineSearch.addEventListener('input', function() {
        const searchTerm = this.value.trim().toLowerCase();
        
        if (searchTerm.length === 0) {
            suggestions.style.display = 'none';
            return;
        }
        
        // Filter medicines that start with the search term
        const filteredMedicines = medicineDatabase.filter(medicine => 
            medicine.toLowerCase().startsWith(searchTerm)
        );
        
        displaySuggestions(filteredMedicines);
    });
    
    // Display suggestions
    function displaySuggestions(medicines) {
        suggestions.innerHTML = '';
        
        if (medicines.length === 0) {
            suggestions.style.display = 'none';
            return;
        }
        
        medicines.forEach(medicine => {
            const suggestionItem = document.createElement('a');
            suggestionItem.href = '#';
            suggestionItem.className = 'list-group-item list-group-item-action';
            suggestionItem.textContent = medicine;
            
            suggestionItem.addEventListener('click', function(e) {
                e.preventDefault();
                addMedicine(medicine);
                medicineSearch.value = '';
                suggestions.style.display = 'none';
            });
            
            suggestions.appendChild(suggestionItem);
        });
        
        suggestions.style.display = 'block';
    }
    
    // Add medicine to selected list
    function addMedicine(medicine) {
        const medicineItem = document.createElement('div');
        medicineItem.className = 'd-flex justify-content-between align-items-center mb-2 p-2 bg-light rounded';
        
        medicineItem.innerHTML = `
            <span>${medicine}</span>
            <button class="btn btn-sm btn-outline-danger remove-medicine">
                <i class="bi bi-trash"></i>
            </button>
        `;
        
        // Add remove functionality
        medicineItem.querySelector('.remove-medicine').addEventListener('click', function() {
            medicineItem.remove();
        });
        
        selectedMedicines.appendChild(medicineItem);
    }
    
    // Clear search
    clearSearch.addEventListener('click', function() {
        medicineSearch.value = '';
        suggestions.style.display = 'none';
    });
    
    // Hide suggestions when clicking outside
    document.addEventListener('click', function(e) {
        if (!medicineSearch.contains(e.target) && !suggestions.contains(e.target)) {
            suggestions.style.display = 'none';
        }
    });
});