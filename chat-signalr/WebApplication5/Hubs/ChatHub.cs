using Microsoft.AspNetCore.SignalR;

namespace SignalRChat.Hubs
{
    public class ChatHub : Hub
    {
        public async Task Send(object sender, string message)
        {
            // Broadcast the message to all clients except the sender.
            await Clients.Others.SendAsync("broadcastMessage", sender, message);
        }

        public async Task SendTyping(object sender)
        {
            // Broadcast the typing notification to all clients except the sender.
            await Clients.Others.SendAsync("typing", sender);
        }
    }
}
