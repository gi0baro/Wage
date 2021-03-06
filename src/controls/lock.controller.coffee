class LockController extends Wage.Controller
    constructor: (options={}) ->
        @_defaults =
            height: 5
            crouch: 0.25
            jumpHeight: 5
            speed: 0.5
            fallFactor: 0.25
            delta: 0.1
            mouseFactor: 0.002
        super options
        {camera} = Wage
        camera.rotation.set 0, 0, 0
        @pitch = new THREE.Object3D()
        @yaw = new THREE.Object3D()
        @velocity = new THREE.Vector3()
        @yaw.position.y = @config.height
        @pitch.add camera
        @yaw.add @pitch
        @state =
            forward: false
            backward: false
            left: false
            right: false
            velocity: @config.speed
        @isOnObject = false
        @canJump = false
        @shiftClicked = false
        @enabled = false
        return

    keydownW: ->
        @state.forward = 1

    keyupW: ->
        @state.forward = 0

    keydownA: ->
        @state.left = 1

    keyupA: ->
        @state.left = 0

    keydownS: ->
        @state.back = 1

    keyupS: ->
        @state.back = 0

    keydownD: ->
        @state.right = 1

    keydownSpace: ->
        if canJump
            @velocity.y += @config.jumpHeight
        canJump = false

    keydownShift: ->
        @state.velocity = @config.crouch
        @yaw.position.y = @config.height/2
        @canJump = false
        @shiftClicked = true

    keyupShift: ->
        @state.velocity = @config.speed
        @yaw.position.y = @config.height
        @canJump = true
        @shiftClicked = false

    mousemove: (e) ->
        if not @enabled
            return
        moveX = e.movementX or e.mozMovementX or e.webkitMovementX or 0
        moveY = e.movementY or e.mozMovementY or e.webkitMovementY or 0
        @yaw.rotation.y -= moveX * @config.mouseFactor
        @pitch.rotation.x = moveY * @config.mouseFactor
        @pitch.rotation.x = Math.max -Math.PI/2, Math.min(Math.PI/2, @pitch.rotation.x)
        return

    update: (dt) ->
        alpha = dt * @config.delta
        @velocity.y -= @config.fallFactor * alpha
        v = @config.speed
        if @state.forward
            velocity.z = -v
        if @state.backward
            velocity.z = v
        if not @state.forward and not @state.backward
            velocity.z = 0
        if @state.left
            velocity.x = -v
        if @state.right
            @velocity.x = v
        if not @state.left and not @state.right
            @velocity.x = 0
        if @isOnObject
            velocity.y = Math.max 0, @velocity.y
        @yaw.translateX @velocity.x
        @yaw.translateY @velocity.y
        @yaw.translateZ @velocity.z
        if @yaw.position.y < @config.height
            @velocity.y = 0
            @yaw.position.y = if @shiftClicked then @config.height / 2 else @config.height
            @canJump = true
        return

env = self.Wage ?= {}
env.LockController = LockController
