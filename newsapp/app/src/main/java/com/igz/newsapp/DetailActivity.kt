package com.igz.newsapp

import android.content.Intent
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.appbar.MaterialToolbar
import android.widget.ImageView
import android.widget.TextView

class DetailActivity : AppCompatActivity() {
    private lateinit var title: String
    private lateinit var description: String
    private var imageResId: Int = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_detail)

        val toolbar = findViewById<MaterialToolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        toolbar.setNavigationOnClickListener { onBackPressedDispatcher.onBackPressed() }

        title = intent.getStringExtra("title") ?: ""
        description = intent.getStringExtra("description") ?: ""
        imageResId = intent.getIntExtra("imageResId", 0)

        findViewById<TextView>(R.id.tvTitle).text = title
        findViewById<TextView>(R.id.tvDescription).text = description
        findViewById<ImageView>(R.id.imgHeader).setImageResource(imageResId)
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.menu_detail, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            R.id.action_share -> {
                val shareIntent = Intent(Intent.ACTION_SEND).apply {
                    type = "text/plain"
                    putExtra(Intent.EXTRA_SUBJECT, title)
                    putExtra(Intent.EXTRA_TEXT, "$title\n\n$description")
                }
                startActivity(Intent.createChooser(shareIntent, getString(R.string.app_name)))
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }
}
