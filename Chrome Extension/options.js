document.addEventListener('DOMContentLoaded', restore_options);

function saveOptions() {
    var specialCursor = document.getElementById('specialCursor').checked;
    var autoScroll = document.getElementById('autoScroll').checked;
    document.getElementById('scrollBox').disabled = !autoScroll;
    var scrollBox = document.getElementById('scrollBox').checked;
    
    chrome.storage.sync.set({
        enableCursor: specialCursor,
        enableScroll: autoScroll,
        showScrollBox: scrollBox
    }, function() {
        // Update status to let user know options were saved.
        var status = document.getElementById('status');
        status.style.opacity = 1;
        setTimeout(function() {
            status.style.opacity = 0;
        }, 750);
    });
}
    
function restore_options() {
    document.getElementById('specialCursor').addEventListener("click",saveOptions);
    document.getElementById('autoScroll').addEventListener("click",saveOptions);
    document.getElementById('scrollBox').addEventListener("click",saveOptions);

    chrome.storage.sync.get({
        enableCursor: true,
        enableScroll: true,
        showScrollBox: true
    }, function(items) {
        document.getElementById('specialCursor').checked = items.enableCursor;
        document.getElementById('autoScroll').checked = items.enableScroll;
        document.getElementById('scrollBox').disabled = !items.enableScroll;
        document.getElementById('scrollBox').checked = items.showScrollBox;
    });
}