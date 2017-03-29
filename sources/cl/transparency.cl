
#include "light.h"

void	clearness_color(t_data *data)
{
	data->safe++;

	data->rd_light += check_all_light(data);
	data->light_pow *= (1.0f - data->objs[data->id].opacity);
	if (data->objs[data->id].opacity < 1.0f)
		clearness_calcul(data);
}

void	clearness_calcul(t_data *data)
{
	short	index = data->id;

	// *ray_dir = calcul_refract_ray(data, 1.0f, data->objs[data->id].refract);
	data->ray_pos = data->intersect + data->ray_dir;
	check_intercept(data, index, 1);
	if (index == data->id)
	{
		// *ray_dir = calcul_refract_ray(data, data->objs[data->id].refract, 1.0f);
		data->ray_pos = data->intersect + data->ray_dir;
		check_intercept(data, index, 1);
	}
	if (data->id == -1)
	{
		data->rd_light = (float3){0.0f, 0.0f, 0.0f} * data->light_pow;
		data->rd_light = 0.0f;
		data->light_pow = 0.0f;
	}
	else
		data->rd_light += (check_all_light(data) * data->light_pow);
}

float3	calcul_refract_ray(t_data *data, float refract1, float refract2)
{
	float	n;
	float	c1;
	float	c2;
	float3	normale;

	normale = calcul_normale(data);
	n = refract1 / refract2;
	return (data->ray_dir * n + normale * (n * c1 - c2));
}
