package com.example.flowers_app

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    private fun getTfliteInterpreter(modelPath: String): Interpreter? {
        try {
            return Interpreter(loadModelFile(this@MainActivity, modelPath))
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return null
    }


    @kotlin.Throws(IOException::class)
    fun loadModelFile(activity: Activity, modelPath: String?): MappedByteBuffer? {
        val fileDescriptor: AssetFileDescriptor = activity.getAssets().openFd(modelPath)
        val inputStream = FileInputStream(fileDescriptor.getFileDescriptor())
        val fileChannel: FileChannel = inputStream.getChannel()
        val startOffset: Long = fileDescriptor.getStartOffset()
        val declaredLength: Long = fileDescriptor.getDeclaredLength()
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength)
    }
}
