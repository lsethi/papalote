/**
 * ChatService.sendMessage(message) => Used for sending a message from
 *    the user to the node server.
 * 
 * ChatService.setSocketListener() => Used to set event listeners on
 *    the Angular webpage. The connect_error displays an error when
 *    the Angular webpage cannot establish a connection with the node
 *    chat server. The receive message listener is waiting to receive
 *    a message from the node server and pushes that message in the
 *    messages array which is then updated in real time on the webpage.
 */

app.factory('ChatService', ['Socket', 'User', function(Socket, User) {
  var messages = [];
  var emitEventName = "chat message";
  var receiveEventName = "receive message";
  var connectError = "connect_error";
  var joinRoom = "join room";

  return {
    sendMessage: function(message) {
      message.user = User.currentUser.name;
      Socket.emit(
        emitEventName,
        message
      );
    },
    setSocketListener: function(room) {
      Socket.removeAllListeners(receiveEventName);
      Socket.on(receiveEventName, function(message) {
        messages.push(message);
      });
      Socket.on(connectError, function(){
        messages.push({
          user: User.currentUser.name,
          message: 'Failed to connect to the chat server...'
        });
      });
      Socket.emit(
        joinRoom,
        room
      );
    },
    resetMessages: function(){
      messages.length = 0;
    },
    messages: messages
  }
}]);