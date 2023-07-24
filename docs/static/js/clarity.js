$(document).ready(function() {
    $.ajax({
        type: "GET",
        url: "/.auth/me",
        success: function(data) {
            if (data[0] && data[0].user_id) {
                // Set identifier as hashed user id
                window.clarity("identify", data[0].user_id);

                // If user_id contains microsoft.com, set internal to true
                if (data[0].user_id.includes("microsoft.com")) {
                    window.clarity("set", "internal", "true");
                }
                else {
                    window.clarity("set", "internal", "false");
                }
            }
        }
    });
});
