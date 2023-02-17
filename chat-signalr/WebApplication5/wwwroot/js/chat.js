

var connection = new signalR.HubConnectionBuilder().withUrl("/chatHub").build();

//Disable the send button until connection is established.



connection.start().then(function () {
   
}).catch(function (err) {
    return console.error(err.toString());
});

var chat = $("#chat").kendoChat({
    // Each instance of the application will generate a unique username.
    // In this way, the SignalR Hub "knows" who is the user that sends the message
    // and who are the clients that have to receive that message.
    user: {
        name: kendo.guid(),
        iconUrl: "https://demos.telerik.com/kendo-ui/content/chat/avatar.png"
    },
    // This will notify the SignallR Hub that the current client is typing.
    // The Hub, in turn, will notify all the other clients
    // that the user has started typing.
    typingStart: function () {
        connection.invoke("sendTyping", chat.getUser());
    },
    // The post handler will send the user data and the typed text to the SignalR Hub.
    // The Hub will then forward that info to the other clients.
    post: function (args) {
        connection.invoke("send", chat.getUser(), args.text);
    }
}).data("kendoChat");


connection.on('broadcastMessage', function (sender, message) {
    var message = {
        type: 'text',
        text: message
    };

    // Render the received message in the Chat.
    chat.renderMessage(message, sender);
});

connection.on('typing', function (sender) {
    // Display the typing notification in the Chat.
    chat.renderMessage({ type: 'typing' }, sender);
});