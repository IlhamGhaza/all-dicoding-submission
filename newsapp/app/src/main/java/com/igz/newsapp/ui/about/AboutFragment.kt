package com.igz.newsapp.ui.about

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import com.igz.newsapp.R

class AboutFragment : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_about, container, false)
        view.findViewById<TextView>(R.id.tvName).text = "Muhammad Ilham Ghazali"
        view.findViewById<TextView>(R.id.tvEmail).text = "milhamghazali442@gmail.com"
        return view
    }
}
