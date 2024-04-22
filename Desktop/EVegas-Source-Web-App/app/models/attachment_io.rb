class AttachmentIo < StringIO
    def original_filename
        # the real name does not matter
        "avatar.jpeg"
    end

    def content_type
        # this should reflect real content type, but for this example it's ok
        "image/jpeg"  
    end
end