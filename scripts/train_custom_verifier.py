import openwakeword

openwakeword.train_custom_verifier(
    positive_reference_clips="/Users/Mike/Documents/coding/VoiceAssistants/recordings/meghan",
    output_path="/Users/Mike/Documents/coding/VoiceAssistants/recordings/meghan-mike.pkl",
    model_name="/Users/Mike/Downloads/meghan.tflite",
    negative_reference_clips="/Users/Mike/Downloads/oww"
    )
