import Player from './player';

let Video = {
  init(socket, element) {
    if(!element)
      return

    let playerId = element.getAttribute("data-player-id")
    let videoId  = element.getAttribute("data-id")

    socket.connect()

    Player.init(element.id, playerId, () => {
      this.onReady(videoId, socket)
    })
  },

  onReady(videoId, socket) {
    let msgContainer = document.getElementById("msg-container")
    let msgInput     = document.getElementById("msg-input")
    let postButton   = document.getElementById("msg-submit")
    let lastSeenId   = 0

    let channelName = "videos:" + videoId
    console.log("Channel name: ", channelName)
    let vidChannel   = socket.channel(channelName, ()=> {
      return { last_seen_id: lastSeenId }
    })

    postButton.addEventListener("click", (e) => {
      let payload = { body: msgInput.value, at: Player.getCurrentTime()}
      console.log("Payload: ", payload)

      vidChannel.push("new_annotation", payload)
                .receive("error", (e) => {
                  console.log("receive error: ", e)
                })
      msgInput.value = ""
    })

    msgContainer.addEventListener("click", (e) => {
      e.preventDefault()
      let seconds = e.target.getAttribute("data-seek") || e.target.parentNode.getAttribute("data-seek")
      if(!seconds) {
        return 
      }
      Player.seekTo(seconds)
    })

    vidChannel.on("new_annotation", (resp) => {
      console.log("receiving data", resp)
      lastSeenId = resp.id
      this.renderAnnotation(msgContainer, resp)
    })

    vidChannel.join()
              .receive("ok", (resp) => {
                let ids = resp.annotations.map(ann => ann.id)
                if(ids.length > 0 ) { lastSeenId = Math.max(...ids)}
                console.log("Join and Receive the video channel successfully:", resp)
                this.scheduleMessages(msgContainer, resp.annotations)
              })
              .receive("error", (reason) => { console.log("Join failed: ", reason)})

    vidChannel.on("ping", (resp) => {
      console.log("on ping: ", resp)
    })
  },

  renderAnnotation(msgContainer, {user, body, at}) {
    let template = document.createElement("div")
    template.innerHTML = `
      <a href='#' data-seek="${this.esc(at)}" >
        [${this.formateTime(at)}]
        <b>${this.esc(user.username)}</b>: ${this.esc(body)}
      </a>
    `
    msgContainer.appendChild(template)
    msgContainer.scrollTop = msgContainer.scrollHeight
  },

  esc(str){
    let div = document.createElement("div")
    div.appendChild(document.createTextNode(str))
    return div.innerHTML
  },

  scheduleMessages(msgContainer, annotations) {
    clearTimeout(this.scheduleTimer)
    this.scheduleTimer = setTimeout(()=> {
      let ctime = Player.getCurrentTime()
      let remaining = this.renderAtTime(annotations, ctime, msgContainer)
      this.scheduleMessages(msgContainer, remaining)
    }, 1000)
  },

  renderAtTime(annotations, seconds, msgContainer) {
    return annotations.filter((ann)=> {
      if(ann.at > seconds) {
        return true
      }
      else{
        this.renderAnnotation(msgContainer, ann)
        return false
      }
    })
  },

  formateTime(at) {
    let date = new Date(null)
    date.setSeconds(at/1000)
    return date.toISOString().substr(15, 5)
  }

}

export default Video