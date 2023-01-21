#include "allegro5/allegro5.h"
#include <iostream>

extern "C" void lissajous(unsigned *pixels, int width, int height, double a, double b, double fi);

void curve(ALLEGRO_BITMAP* bmp, int width, int height, double a, double b, double fi){
    
    //32 bits per pixel
    ALLEGRO_LOCKED_REGION *region = al_lock_bitmap(bmp, al_get_bitmap_format(bmp), ALLEGRO_LOCK_WRITEONLY);
    unsigned* pixels = (unsigned*) region->data;
    
    //move pointer from upper left corner to bottom left corner
    pixels += width;
    pixels -= width * height;
    lissajous(pixels, width, height, a, b, fi);  
    al_unlock_bitmap(bmp);
  	al_clear_to_color(al_map_rgb(255, 93, 106));
    al_draw_bitmap(bmp, 0, 0, 0);
    al_flip_display();
}

int main()
{   
    int width = 512;
    int height = 512;
    double a = 0.5;
    double b = 1.0;
    double fi = -3.14156;
    bool done = false;

    al_init();
    al_install_keyboard();

    ALLEGRO_EVENT_QUEUE* queue = al_create_event_queue();
    ALLEGRO_DISPLAY* disp = al_create_display(width, height);
    ALLEGRO_BITMAP *bmp = al_create_bitmap(width, height);

    al_set_window_title(disp,"Lissajous curve");

    al_register_event_source(queue, al_get_keyboard_event_source());

    curve(bmp, width, height, a, b, fi);
    
    while(!done)
    {
        ALLEGRO_EVENT event;

        al_wait_for_event(queue, &event);

        if(event.type == ALLEGRO_EVENT_KEY_DOWN){
            bmp = al_create_bitmap(width, height);
            switch (event.keyboard.keycode)
            {
            case ALLEGRO_KEY_ESCAPE:
                done = true;
                al_destroy_display(disp);
                al_destroy_event_queue(queue);
                al_destroy_bitmap(bmp);
                break;

            case ALLEGRO_KEY_RIGHT:
                a += 0.05;
                curve(bmp, width, height, a, b, fi);
                break;

            case ALLEGRO_KEY_LEFT:
                a -= 0.05;
                curve(bmp, width, height, a, b, fi);
                break;

            case ALLEGRO_KEY_UP:
                b += 0.05;
                curve(bmp, width, height, a, b, fi);
                break;

            case ALLEGRO_KEY_DOWN:
                b -= 0.05;
                curve(bmp, width, height, a, b, fi);
                break;

            case ALLEGRO_KEY_PAD_6:
                fi += 0.05;
                curve(bmp, width, height, a, b, fi);
                break;

            case ALLEGRO_KEY_PAD_4:
                fi -= 0.05;
                curve(bmp, width, height, a, b, fi);
                break;
            }
            std::cout << "a: " << a << std::endl;
            std::cout << "b: "  << b << std::endl;
            std::cout << "fi: "  << fi << std::endl;
            std::cout << std::endl;
        }
    }

    return 0;
}