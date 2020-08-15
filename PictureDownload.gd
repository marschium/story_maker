extends Control

export var url = "https://bceycompa4.execute-api.eu-west-1.amazonaws.com/prod/img?q="

signal image_picked(image)


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _on_SearchButton_pressed():
    var term = $VBoxContainer/HBoxContainer/SearchLineEdit.text
    if term:
        var search_url = url + term
        $VBoxContainer/HBoxContainer/SearchLineEdit.text = ""
        for n in $VBoxContainer/ScrollContainer/ImageGridContainer.get_children():
            $VBoxContainer/ScrollContainer/ImageGridContainer.remove_child(n)
            n.queue_free()
        $SearchHTTPRequest.request(search_url)
    else:
        pass # TODO some error

func _on_SearchHTTPRequest_request_completed(result, response_code, headers, body):    
    print(response_code)
    var json = JSON.parse(body.get_string_from_utf8()).result
    for hit in json.hits:
        var http_request = HTTPRequest.new()
        add_child(http_request)
        http_request.connect("request_completed", self, "_on_DownloadHTTPRequest_request_completed")
        http_request.request(hit)


func _on_DownloadHTTPRequest_request_completed(result, response_code, headers, body):
    var content_type = headers[1]
    var image = Image.new()
    var error = OK
    if content_type == "Content-Type: image/jpeg":
        error = image.load_jpg_from_buffer(body)
    else:
        error = image.load_png_from_buffer(body)
    if error != OK:
        push_error("Couldn't load the image.")

    var texture = ImageTexture.new()
    texture.create_from_image(image)
    
    var texture_rect = TextureRect.new()
    texture_rect.connect("gui_input", self, "_on_TextureRect_gui_input", [texture_rect])
    texture_rect.texture = texture
    texture_rect.expand = true
    texture_rect.rect_min_size = Vector2(164, 164)
    $VBoxContainer/ScrollContainer/ImageGridContainer.add_child(texture_rect)
    
func _on_TextureRect_gui_input(event, texture_rect):
    if event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and not event.is_pressed():
        var texture = texture_rect.texture
        var raw_image = texture.get_data()
        emit_signal("image_picked", raw_image)


func _on_SearchLineEdit_text_entered(new_text):
    _on_SearchButton_pressed()
