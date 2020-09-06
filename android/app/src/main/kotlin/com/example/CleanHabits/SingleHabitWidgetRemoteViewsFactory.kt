package com.example.CleanHabits

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.util.Log
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.*

class SingleHabitWidgetRemoteViewsFactory: RemoteViewsService.RemoteViewsFactory  {

    private val TAG = this::class.java.simpleName
    private val _dtFormat = DateTimeFormatter.ofPattern("dd-MM-yyyy")

    private val mContext: Context
    private var appWidgetId = 0

    private var days = listOf("SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT")
    private var progress: Map<LocalDate, Boolean> = mapOf<LocalDate, Boolean>()

    constructor(mContext: Context, intent: Intent?) {
        this.mContext = mContext
        appWidgetId = intent?.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID)!!;

        var pProgress = intent?.getSerializableExtra("progress") as Map<String, Int>
        for((strDate, progress) in pProgress) {
            var ldDate = LocalDate.parse(strDate, _dtFormat);
            this.progress += Pair(ldDate, progress > 0);
        }
    }

    override fun onCreate() {
    }

    override fun onDataSetChanged() {
    }

    override fun onDestroy() {
    }

    override fun getCount(): Int {
        return 42
    }

    override fun getViewAt(position: Int): RemoteViews {

        if(position < days.size){
            return RemoteViews(mContext.packageName, R.layout.calender_item).apply{
                setTextViewText(R.id.calenderItemText, days[position])
                setTextColor(R.id.calenderItemText, Color.parseColor( "#FF056676" ))
            }
        } else {

            val now = LocalDate.now()
            val monthStart = now.minusDays((now.dayOfMonth - 1).toLong())
            val dayOfWeek = monthStart.dayOfWeek.value
            val calStart = monthStart.minusDays((dayOfWeek - 0).toLong())
            val dateToShow = calStart.plusDays((position - days.size).toLong())

            var doHighlight = this.progress[dateToShow];
            if ( doHighlight != null && doHighlight ) {
                return RemoteViews(mContext.packageName, R.layout.calender_item_selected).apply {

                    val textColorHex = "#FFFFFFFF"

                    setTextColor(R.id.calenderItemText, Color.parseColor(textColorHex))
                    setTextViewText(R.id.calenderItemText, dateToShow.dayOfMonth.toString())
                }

            } else if ( dateToShow.isEqual(now) ) {
                return RemoteViews(mContext.packageName, R.layout.calender_item_unselected).apply {

                    val textColorHex = "#000000"

                    setTextColor(R.id.calenderItemText, Color.parseColor(textColorHex))
                    setTextViewText(R.id.calenderItemText, dateToShow.dayOfMonth.toString())
                }

            } else {
                return RemoteViews(mContext.packageName, R.layout.calender_item).apply {

                    val currentMonth = now.month.value
                    val monthToShow = dateToShow.month.value
                    val textColorHex = if (currentMonth == monthToShow) "#000000" else "#A39E93"

                    setTextColor(R.id.calenderItemText, Color.parseColor(textColorHex))
                    setTextViewText(R.id.calenderItemText, dateToShow.dayOfMonth.toString())
                }
            }
        }
    }

    override fun getLoadingView(): RemoteViews {
        val rv = RemoteViews(mContext.packageName, R.layout.widget_loading)
        rv.setTextViewText(R.id.widgetLoadingText, ".")
        return rv
    }

    override fun getViewTypeCount(): Int {
        return 3
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun hasStableIds(): Boolean {
       return true
    }
}