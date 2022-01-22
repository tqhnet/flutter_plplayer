package com.tqh.plugin_plplayer;

import android.content.Context;
import android.util.Log;

import com.pili.pldroid.player.widget.PLVideoTextureView;

public class VideoManange {
    static  PLVideoTextureView player;

    public static PLVideoTextureView getInstance(Context context) {
        if (player == null) {
            Log.e("七牛","七牛===player****==");
            player = new PLVideoTextureView(context);
        }
        return player;
    }


}
