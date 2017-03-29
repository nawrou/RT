/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   calc.cl                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lgatibel <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/02/09 17:50:51 by lgatibel          #+#    #+#             */
/*   Updated: 2017/02/13 11:10:55 by lgatibel         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "obj_def.h"
#include "calc.h"
#include "light.h"
#include "light.cl"
#include "calc_intersect.cl"
#include "rotate.cl"

float		calc_delta(float a, float b, float c)
{
	float	t0;
	float	t1;
	float	t;
	float	tmp;

	tmp = (b * b) - (4.0f * a * c);
	if(tmp < 0.0f)
		return (-1);
	tmp = sqrt(tmp);
	t0 = ((-b + tmp) / (2.0f * a));
	t1 = ((-b - tmp) / (2.0f * a));
	t = (t0 < t1) ? t0 : t1;
	return (t);
}

static short	ray_intersection(t_data *data, short *index)
{
	data->obj = &data->objs[(int)*index];
	if (data->obj->type == T_PLANE)
		return (plane_intersection(data));
	else if (data->obj->type == T_CONE)
		return (cone_intersection(data));
	else if (data->obj->type == T_CYLINDER)
		return (cylinder_intersection(data));
	else if (data->obj->type == T_SPHERE)
		return (sphere_intersection(data));
	//else if (data->obj->type == T_DISK)
	// 	return (disk_intersection(data));
	return (0);
}

void			touch_object(t_data *data)
{
	short			index;
	float			smallest_norm;
	float			norm;
	float3			closest_intersect;

	float	t;
	t = -1;

	index = -1;
	data->id = -1;
	smallest_norm = -1;
	data->option = 1;
	while(++index <  data->n_objs)
	{
		if (ray_intersection(data, &index))
			if ((norm = fast_distance(data->intersect, data->ray_pos)) > 0.0f &&
				(norm < smallest_norm || smallest_norm == -1))
			{
				closest_intersect = data->intersect;
				smallest_norm = norm;
				data->id = index;
				data->off_set = data->offset;
				t = data->t;
			}
	}
	data->t = t;
	data->option = 0;
	data->intersect = closest_intersect;
}

static void		init_data(t_data *data, global t_obj *objs,
global t_lgt *lgts, short n_objs, short n_lgts, float3 ray_pos,
float3 ray_dir, float ambiant, global unsigned int *pixel)
{
	data->objs = objs;
	data->obj = 0;
	data->lights = lgts;
	data->pixel = pixel;
	data->n_objs = n_objs;
	data->n_lgts = n_lgts;
	data->id = -1;
	data->safe = SAFE;
	data->option = 1;
	data->nl = 0;
	data->ambiant = ambiant;
	data->light_pow = 1.0f;
	data->ray_pos = ray_pos;
	data->grid_ray_dir = ray_dir;
	data->ray_dir = ray_dir;
	data->intersect = 0.0f;
	data->grid_intersect = 0.0f;
	data->rd_light = 0.0f;
	data->offset = 0.0f;
	data->rad = 0.0f;

	data->off_set = 0.0f;
	data->t = 0.0f;
	data->rot = (float3){0.f, 1.0f, 0.0f};
	data->test = -8;
	data->pos = (float3){0.0f, 1.0f, 0.0f};
}

void calc_picture(int debug, global unsigned int *pixel, global t_obj *objs,
	global t_lgt *lgts, short n_objs, short n_lgts, float3 ray_pos,
	float3 ray_dir, global t_cam *cam, short x, short y)
{
	t_data	data;
	float	ambiant = 0.20f;
	init_data(&data, objs, lgts, n_objs, n_lgts, ray_pos, ray_dir, ambiant, pixel);
	init_laputain_desamere(&data);
	check_intercept(&data, data.id, 0);
	if (!COLOR && data.id > -1)
	{
		if (data.id == 0){*(data.pixel) = 0x00ff00FF;}
		else if (data.id == 1){*pixel = 0xff0000FF;}
		else if (data.id == 2){*pixel = 0x00ffffFF;}
		else if (data.id == 3){*pixel = 0xffffffFF;}
		else if (data.id == 4){*pixel = 0xffff00FF;}
		else{*pixel = 0xff00ffFF;}
	}
	else if (COLOR && data.id > -1)
	{
		// printf("c'est la faute d'erwan!!!!!!\n");
		*pixel = get_lighting(&data);
	}
	else
		*pixel = FONT;
}
