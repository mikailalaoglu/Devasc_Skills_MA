document.addEventListener("DOMContentLoaded", function() {
    
    function updateDateTime() {
      
        var currentDate = new Date();
        var formattedDateTime = currentDate.toLocaleString();
        document.getElementById("datetime").innerText = formattedDateTime;
    }

    // Initial call to update date and time
    updateDateTime();

   
    setInterval(updateDateTime, 1000);
});