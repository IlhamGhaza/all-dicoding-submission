package com.igz.newsapp.ui.home

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.igz.newsapp.R
import com.igz.newsapp.data.SampleArticles

class HomeFragment : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_home, container, false)
        val rv = view.findViewById<RecyclerView>(R.id.recyclerArticles)
        rv.layoutManager = LinearLayoutManager(requireContext())
        rv.adapter = ArticleAdapter(SampleArticles.list)
        return view
    }
}
