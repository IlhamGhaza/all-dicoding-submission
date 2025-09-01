package com.igz.newsapp.ui.home

import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.igz.newsapp.DetailActivity
import com.igz.newsapp.R
import com.igz.newsapp.data.Article

class ArticleAdapter(private val items: List<Article>) : RecyclerView.Adapter<ArticleAdapter.VH>() {

    inner class VH(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val img: ImageView = itemView.findViewById(R.id.imgThumb)
        val title: TextView = itemView.findViewById(R.id.tvTitle)
        val overview: TextView = itemView.findViewById(R.id.tvOverview)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.item_article, parent, false)
        return VH(view)
    }

    override fun onBindViewHolder(holder: VH, position: Int) {
        val item = items[position]
        holder.title.text = item.title
        holder.overview.text = item.overview
        holder.img.setImageResource(item.imageResId)
        holder.itemView.setOnClickListener {
            val ctx = holder.itemView.context
            val intent = Intent(ctx, DetailActivity::class.java).apply {
                putExtra("title", item.title)
                putExtra("overview", item.overview)
                putExtra("description", item.description)
                putExtra("imageResId", item.imageResId)
            }
            ctx.startActivity(intent)
        }
    }

    override fun getItemCount(): Int = items.size
}
