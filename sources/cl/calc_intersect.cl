/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   calc_intersect.cl                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: lgatibel <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/02/13 11:11:30 by lgatibel          #+#    #+#             */
/*   Updated: 2017/02/13 11:11:39 by lgatibel         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

float			float3_to_float(float3 v){
	return (v.x + v.y + v.z);
}

void			calc_intersect(float *delta, t_data *data)
{
	data->t = *delta;
	data->intersect = data->ray_pos + (data->ray_dir * (*delta));
	data->grid_intersect = data->ray_pos + (data->grid_ray_dir * (*delta));
}

short			disk_intersection(t_data *data)
{
	float	div;
	float	t;
	// float3	pos;

	data->option = 3;
	data->rot = rotate_ray(&data->rot, data);
	data->offset = data->ray_pos - data->pos;

	div = dot(data->rot, data->ray_dir);
	if (div == 0.0f)
		return (0);
	t = (-dot(data->rot, data->offset)) / div;
	if (t < 0.0f)
		return (0);
	t += (t < 0)? t * -PLANE_PREC: t * PLANE_PREC;
	calc_intersect(&t, data);
	if (data->obj->radius > 0.0f && fast_distance(data->grid_intersect,
	 data->pos) > data->obj->radius)
		return (0);
	return (1);
}

short			plane_intersection(t_data *data)
{
	float	div;
	float	t;

	data->option = 2;
	data->rot = rotate_ray(&data->rot, data);
	data->offset = data->ray_pos - data->obj->pos;
/*
	div = dot((float3){0.0f, 1.0f, 0.0f}, data->ray_dir);
	if (div == 0.0f)
		return (0);
	t = (-dot((float3){0.0f, 1.0f, 0.0f}, data->offset)) / div;
	if (t < 0.0f)
		return (0);
	t += (t < 0)? t * -PLANE_PREC: t * PLANE_PREC;
	data->delta = t;
*/
	div = dot(data->rot, data->ray_dir);
	if (div == 0.0f)
		return (0);
	t = (-dot(data->rot, data->offset)) / div;
	if (t < 0.0f)
		return (0);
	t += (t < 0)? t * -PLANE_PREC: t * PLANE_PREC;
	calc_intersect(&t, data);
	// if (data->obj->width > 0.0f && fast_distance(data->grid_intersect.x,
	//  data->obj->pos.x) > (data->obj->width / 2.0f))
	// 	return (0);
	// if (data->obj->height > 0.0f && fast_distance(data->grid_intersect.z,
	//  data->obj->pos.z) > (data->obj->height / 2.0f))
	// 	return (0);
	// data->radius = 4;
	// if (data->radius > 0.0f && fast_distance(data->grid_intersect,
	//  data->obj->pos) > data->radius)
	// 	return (0);
//	 if (data->obj->width > 0.0f && fast_distance(data->grid_intersect.x,
//	  data->obj->pos.x) > (data->obj->width / 2.0f))
//	 	return (0);
//	 if (data->obj->height > 0.0f && fast_distance(data->grid_intersect.z,
//	  data->obj->pos.z) > (data->obj->height / 2.0f))
//	 	return (0);
	// PRINT3(data->obj->rot,"normal");
	return (1);
}

short			cone_intersection(t_data *data)
{
	float	a;
	float	b;
	float	c;
	float	delta;

	float	rad;
	rad = (data->obj->radius / 2.0f) * (float)(M_PI / 180.0f);

	float tanj;
	tanj = 1.0f + tan(rad) * tan(rad); 
	
	data->ray_dir = rotate_ray(&data->ray_dir, data);

	a = dot(data->ray_dir, data->ray_dir) - tanj *
		dot(data->ray_dir, data->rot) * dot(data->ray_dir, data->rot);

	b = 2.0f * (dot(data->ray_dir, data->offset) - tanj *
		dot(data->ray_dir, data->rot) *
		dot(data->offset, data->rot));

	c = dot(data->offset, data->offset) - tanj * 
		dot(data->offset, data->rot) * dot(data->offset, data->rot);

	if ((delta = calc_delta(a, b, c)) < 0.0f)
		return (0);
	calc_intersect(&delta, data);
	
	if ((data->obj->height > 0.0f && ((fast_distance(data->obj->pos, data->grid_intersect) >
	sqrt(data->obj->height * data->obj->height + data->obj->radius  * data->obj->radius)))))
		return (0);
	return (1);
}


short			cylinder_intersection(t_data *data)
{
	float	a;
	float	b;
	float	c;
	float	delta;

	float3	rdir;
	rdir = data->ray_dir;

	data->ray_dir = rotate_ray(&data->ray_dir, data);

	a = dot(data->ray_dir, data->ray_dir) - dot(data->ray_dir,
		(float3){0.0f, 1.0f, 0.0f}) * dot(data->ray_dir,
			(float3){0.0f, 1.0f, 0.0f});

	b = 2.0f * (dot(data->ray_dir, data->offset) - dot(data->ray_dir,
		(float3){0.0f, 1.0f, 0.0f}) *
		dot(data->offset, (float3){0.0f, 1.0f, 0.0f}));

	c = dot(data->offset, data->offset) - dot(data->offset,
		(float3){0.0f, 1.0f, 0.0f}) * dot(data->offset,
			(float3){0.0f, 1.0f, 0.0f}) - data->obj->radius * data->obj->radius;

	if ((delta = calc_delta(a, b, c)) < 0.0f)
		return (0);
		// printf("test\n");
	calc_intersect(&delta, data);
	if (data->obj->height > 0.0f && ((fast_distance(data->obj->pos, data->grid_intersect) > sqrt(data->obj->height *
	data->obj->height + data->obj->radius  * data->obj->radius))))
	{
		// data->rot = (float3){0.0f, 1.0f, 0.0f};
		// data->radius = data->obj->radius;
		data->test = T_DISK;
		if (data->ray_pos.y - data->grid_intersect.y > data->obj->height)
		{
		return (0);
			// data->rot = (float3){0.0f, 1.0f, 0.0f};
			data->pos = (float3){data->obj->pos.x, data->obj->pos.y - data->obj->height,
			data->obj->pos.z};
		}
		else
		{
			data->pos = (float3){data->obj->pos.x, data->obj->pos.y,
			data->obj->pos.z};
			data->pos -= 10.0f * data->rot;
		}
		data->ray_dir = rdir;
		if (!disk_intersection(data))
		// if (sphere_intersection(data) == 1)/// not working a 100%
			return (0);
		return (1);
	}


		// return (0);
	
	return (1);
}

short			sphere_intersection(t_data *data)
{
	float	a;
	float	b;
	float	c;
	float	delta;

	data->ray_dir = rotate_ray(&data->ray_dir, data);
	a = dot(data->ray_dir, data->ray_dir);
	b = 2.0f * dot(data->ray_dir, data->offset);
	c = dot(data->offset, data->offset) -  data->obj->radius * data->obj->radius;
	if ((delta = calc_delta(a, b, c)) < 0.0f)
		return (0);
	calc_intersect(&delta, data);
	return (1);
}
