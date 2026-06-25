    let recognition;
    let listening = false;

    const textarea = document.getElementById("voice-textarea");
    const summarytextarea = document.getElementById("summary-voice-textarea");
    const statusBox = document.getElementById("voice-status");
    const summarizeBtn = document.getElementById("summarize-btn");

    // Character counter
    function updateCounter() {
        const counter = document.getElementById("char-counter");
        counter.textContent = textarea.value.length + " / " + textarea.maxLength;
    }

    function summaryUpdateCounter(){
        const counter = document.getElementById("summary-char-counter");
        counter.textContent = summarytextarea.value.length + " / " + summarytextarea.maxLength;
    }

    // Auto-resize textarea
    function autoResize(el) {
        el.style.height = "auto";
        el.style.height = el.scrollHeight + "px";
    }

// ==============================
// SPEECH RECOGNITION
// ==============================
window.SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

let finalTranscript = ""; // stores confirmed speech

if (window.SpeechRecognition) {
    recognition = new window.SpeechRecognition();
    recognition.continuous = true;
    recognition.interimResults = true;
    recognition.lang = "en-US";

    recognition.onresult = function(event) {
        let interimTranscript = "";

        for (let i = event.resultIndex; i < event.results.length; i++) {
            if (event.results[i].isFinal) {
                // Add confirmed (final) text to the permanent transcript
                finalTranscript += event.results[i][0].transcript + " ";
            } else {
                // Temporary live text
                interimTranscript += event.results[i][0].transcript;
            }
        }

        // Combine final + interim
        let fullText = (finalTranscript + interimTranscript).trim();

        if (fullText.length > textarea.maxLength) {
            fullText = fullText.substring(0, textarea.maxLength);
        }

        textarea.value = fullText;
        updateCounter();
        autoResize(textarea);
    };

    recognition.onstart = function() {
        statusBox.innerHTML = "<span style='color:green;'>Listening...</span>";
    };

    recognition.onend = function() {
        if (listening) recognition.start(); // auto-restart on pause
    };

} else {
    statusBox.innerHTML =
        "<span style='color:red;'>Your browser does not support speech recognition.</span>";
}


// ==============================
// Start / Stop Mic button
// ==============================
document.getElementById("voice-btn").addEventListener("click", function () {
    if (!listening) {
        finalTranscript = textarea.value; // keep old text instead of wiping
        recognition.start();
        listening = true;
        this.classList.remove("btn-danger");
        this.classList.add("btn-warning");
         // FORCE YELLOW
         this.style.backgroundColor = "#E6D129";
         this.style.color = "#000";
         this.innerHTML = '<i class="bi bi-mic-mute-fill"></i> Stop Converting Voice to Text';
         statusBox.innerHTML = "<span style='color:green;'>Listening...</span>";
    } else {
        listening = false;
        recognition.stop();
        this.classList.remove("btn-warning");
        this.classList.add("btn-danger");
        // Restore original styles
        this.style.cssText = "font-size: 1.2em; background-color: #86D5CE; color: #000;";
        this.innerHTML = '<i class="bi bi-mic-fill"></i> Start Converting Voice to Text';
        statusBox.innerHTML = "Click the mic to start again.";
    }
});


    // =====================================================
    //  SUMMARIZE BUTTON WITH LOADER
    // =====================================================
    summarizeBtn.addEventListener("click", async function () {
        const originalText = textarea.value.trim();
        const summaryBox = document.getElementById("summary-voice-textarea");

        if (originalText.length === 0) {
            statusBox.innerHTML = "<span style='color:red;'>Nothing to summarize.</span>";
            return;
        }

        // Turn button into loader
        summarizeBtn.disabled = true;
        summarizeBtn.innerHTML = `
            <span class="spinner-border spinner-border-sm"></span> Summarizing...
        `;

        statusBox.innerHTML = "<span style='color:blue;'>Summarizing...</span>";

        try {
            const response = await fetch('/summarized_content', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ text: originalText })
            });

            if (!response.ok) throw new Error("Failed to summarize text");

            const summary = await response.text();

            // 🔥 Write summary ONLY to summary box
            summaryBox.value = summary;

            // 🔥 Keep original textarea unchanged
            // textarea.value stays as it is

            // Optional: resize summary textarea if needed
            if (typeof autoResize === "function") {
                autoResize(summaryBox);
            }

            statusBox.innerHTML = "<span style='color:green;'>Summary completed.</span>";

        } catch (error) {
            console.error(error);
            statusBox.innerHTML = "<span style='color:red;'>Error summarizing text.</span>";
        } finally {

            // Restore button
            summarizeBtn.disabled = false;
            summarizeBtn.innerHTML = `<i class="bi bi-cpu"></i> Summarize to SOAP EHR Note`;
        }
    });


    // =====================================================
    // CLEAR BUTTON
    // =====================================================
    document.getElementById("clear-btn").addEventListener("click", function () {

        textarea.value = "";
        updateCounter();
        autoResize(textarea);

        this.classList.remove("bi-trash");
        this.classList.add("bi-check-lg");
        this.innerText = " Cleared";

        setTimeout(() => {
            this.classList.remove("bi-check-lg");
            this.classList.add("bi-trash");
            this.innerText = " Clear";
        }, 1000);
    });



    // =====================================================
    // COPY BUTTON
    // =====================================================
    document.getElementById("copy-btn").addEventListener("click", async function () {
        try {
            await navigator.clipboard.writeText(textarea.value);

            this.classList.remove("bi-copy");
            this.classList.add("bi-check-lg");
            this.innerText = " Copied";

            setTimeout(() => {
                this.classList.remove("bi-check-lg");
                this.classList.add("bi-copy");
                this.innerText = " Copy";
            }, 1000);

        } catch (err) {
            console.error("Failed to copy: ", err);
        }
    });



    // =====================================================
    // COPY BUTTON
    // =====================================================
    document.getElementById("summary-copy-btn").addEventListener("click", async function () {
        try {
            await navigator.clipboard.writeText(summarytextarea.value);

            this.classList.remove("bi-copy");
            this.classList.add("bi-check-lg");
            this.innerText = " Copied";

            setTimeout(() => {
                this.classList.remove("bi-check-lg");
                this.classList.add("bi-copy");
                this.innerText = " Copy";
            }, 1000);

        } catch (err) {
            console.error("Failed to copy: ", err);
        }
    });



    // =====================================================
    // CLEAR BUTTON
    // =====================================================
    document.getElementById("summary-clear-btn").addEventListener("click", function () {

        summarytextarea.value = "";
        updateCounter();
        autoResize(textarea);

        this.classList.remove("bi-trash");
        this.classList.add("bi-check-lg");
        this.innerText = " Cleared";

        setTimeout(() => {
            this.classList.remove("bi-check-lg");
            this.classList.add("bi-trash");
            this.innerText = " Clear";
        }, 1000);
    });

