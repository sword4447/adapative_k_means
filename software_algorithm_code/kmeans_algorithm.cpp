#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <cmath>
#include <ctime>
#include <list>
#include <limits>
#include <queue>
#include <algorithm>
#include <stack>
#include <set>
double calculate_distance_norm_2(const std::vector<double> &a, const std::vector<double> &b)
{
    double sum = 0.0;
    for (int i = 0; i < a.size(); ++i)
        sum += (a[i] - b[i]) * (a[i] - b[i]);

    return sqrt(sum);
}

double calculate_square(const std::vector<double> &a, const std::vector<double> &b)
{
    double sum = 0.0;
    for (int i = 0; i < a.size(); ++i)
        sum += (a[i] - b[i]) * (a[i] - b[i]);

    return sum;
}

void vector_a_sub_b(std::vector<double> &a, const std::vector<double> &b)
{
    for (int i = 0; i < a.size(); ++i)
        a[i] -= b[i];
}
void vector_a_add_b(std::vector<double> &a, const std::vector<double> &b)
{
    for (int i = 0; i < a.size(); ++i)
        a[i] += b[i];
}

std::vector<std::vector<double>> data;
void load_data(const std::string &path, const int training_num, const int dimension)
{
    std::ifstream file_in(path);
    if (!file_in.is_open())
    {
        std::cout << "file open failure";
        throw;
    }
    data.resize(training_num);
    for (int i = 0; i < training_num; ++i)
    {
        data[i].resize(dimension);
        for (int j = 0; j < dimension; ++j)
            file_in >> data[i][j];
    }
    file_in.close();
}

class ball_node
{
public:
    ball_node *parent;
    ball_node *left_child;
    ball_node *right_child;
    int belong;

    int num;
    double raidus;
    double distance_to_parent;
    std::vector<double> point_to_node;
    std::vector<double> pivot;
    std::vector<double> sum;
    std::vector<int> point_list;
    std::vector<ball_node *> node_list;

    std::vector<int> test_point_list; //use test

    double up_bound;
    double global_low_bound;
    std::vector<double> group_low_bound;

    void calculate_pivot();
    void calculate_radius();

    //public:
    void set_parent(ball_node *parent)
    {
        this->parent = parent;
    }
    void set_left_child(ball_node *left_child)
    {
        this->left_child = left_child;
    }
    void set_right_child(ball_node *right_child)
    {
        this->right_child = right_child;
    }

    void clear_point_list()
    {
        point_list.clear();
    }
    void add_node(ball_node *p)
    {
        node_list.push_back(p);
    }

    void update_sum();
    void update_distance_to_father();
    void update_bound(const double up_bound, const double global_low_bound)
    {
        this->up_bound = up_bound;
        this->global_low_bound = global_low_bound;
    };
    void set_root_from_father()
    {
        this->distance_to_parent = 0.0;
    };

    double get_radius() const
    {
        return raidus;
    }
    int get_num() const
    {
        return num;
    }
    double get_up_bound() const
    {
        return up_bound;
    }
    double get_global_low_bound() const
    {
        return global_low_bound;
    }
    std::vector<double> get_point_to_node() const
    {
        return point_to_node;
    }
    std::vector<double> get_sum() const
    {
        return sum;
    }
    std::vector<double> get_pivot() const
    {
        return pivot;
    }
    std::vector<int> get_point_list() const
    {
        return point_list;
    }
    std::vector<ball_node *> get_node_list() const
    {
        return node_list;
    }

    bool is_leaf() const
    {
        return !point_list.empty();
    }

    ball_node(std::vector<int> point_list);
    ball_node();
    ~ball_node();
};

void ball_node::calculate_pivot()
{
    pivot.resize(data[0].size(), 0.0);

    for (auto it : point_list)
        for (int j = 0; j < data[it].size(); ++j)
            pivot[j] += data[it][j];

    for (int i = 0; i < pivot.size(); ++i)
        pivot[i] /= point_list.size();
}

void ball_node::calculate_radius()
{
    raidus = 0.0;
    for (auto it : point_list)
        if (calculate_distance_norm_2(data[it], pivot) > raidus)
            raidus = calculate_distance_norm_2(data[it], pivot);
}

ball_node::ball_node(std::vector<int> point_list)
{
    this->point_list = point_list;
    this->point_to_node.resize(point_list.size());

    this->num = point_list.size();

    calculate_pivot();
    calculate_radius();
}

void ball_node::update_sum()
{
    sum.resize(data[0].size(), 0.0);

    if (!point_list.empty())
        for (const auto &it : point_list)
            for (int j = 0; j < data[it].size(); ++j)
                sum[j] += data[it][j];
    else
        for (auto &it : node_list)
        {
            it->update_sum();
            for (int j = 0; j < data[0].size(); ++j)
                sum[j] += (it->get_sum())[j];
        }
}
void ball_node::update_distance_to_father()
{
    if (!point_list.empty())
        for (int i = 0; i < point_list.size(); ++i)
            point_to_node[i] = calculate_distance_norm_2(data[point_list[i]], this->pivot);
    else
        for (auto &it : node_list)
        {
            it->distance_to_parent = calculate_distance_norm_2(it->pivot, this->pivot);

            it->update_distance_to_father();
        }
}
ball_node::ball_node()
{
    up_bound = std::numeric_limits<double>::max();
    global_low_bound = 0.0;
}
ball_node::~ball_node()
{
}

class ball_tree
{
public:
    ball_node *root;

    void set_children(ball_node *p, const int remain_depth, const int capacity);

    void release(ball_node *p);
    ball_tree()
    {
        root = NULL;
    }
    ball_tree(const int max_depth, const int capacity);
    ~ball_tree();
};
void ball_tree::release(ball_node *p)
{
    if (p->left_child != NULL)
        release(p->left_child);
    if (p->right_child != NULL)
        release(p->right_child);
    delete p;
}
ball_tree::ball_tree(const int max_depth, const int capacity)
{
    clock_t star = std::clock();
    std::vector<int> root_list(data.size());
    for (int i = 0; i < root_list.size(); ++i)
        root_list[i] = i;
    root = new ball_node(root_list);
    root->set_parent(nullptr);

    if (max_depth > 1 && data.size() > capacity)
        set_children(root, max_depth - 1, capacity);

    root->update_sum();
    clock_t end = std::clock();
    //std::cout << end - star << '\n';

    root->set_root_from_father();
    root->update_distance_to_father();
}

ball_tree::~ball_tree()
{
    if (root != NULL)
        release(root);
}

void ball_tree::set_children(ball_node *p, const int remain_depth, const int capacity)
{
    int pos = rand() % p->point_list.size();
    std::vector<double> u = data[p->point_list[0]];

    // select furthest point a to u
    std::vector<double> a = u;
    double distance = 0.0;
    for (auto it : p->get_point_list())
        if (calculate_distance_norm_2(data[it], u) > distance)
        {
            distance = calculate_distance_norm_2(data[it], u);
            a = data[it];
        }

    // select furthest point B to A
    std::vector<double> b = a;
    distance = 0.0;
    for (auto it : p->get_point_list())
        if (calculate_distance_norm_2(data[it], a) > distance)
        {
            distance = calculate_distance_norm_2(data[it], a);
            b = data[it];
        }

    std::vector<int> left_list;
    std::vector<int> right_list;
    for (auto it : p->get_point_list())
    {
        double distance_to_a = calculate_distance_norm_2(data[it], a);
        double distance_to_b = calculate_distance_norm_2(data[it], b);

        if (distance_to_a < distance_to_b)
            left_list.push_back(it);
        else
            right_list.push_back(it);
    }

    ball_node *left_child = new ball_node(left_list);
    p->set_left_child(left_child);
    p->add_node(left_child);
    left_child->set_parent(p);
    ball_node *right_child = new ball_node(right_list);
    right_child->set_parent(p);
    p->add_node(right_child);
    p->set_right_child(right_child);

    p->clear_point_list();

    if (remain_depth > 0 && left_list.size() > capacity) //孩子节点是否建立孩子
    {
        set_children(left_child, remain_depth - 1, capacity);
    }
    else
        p->left_child->left_child = p->left_child->right_child = NULL;
    if (remain_depth > 0 && right_list.size() > capacity)
    {
        set_children(right_child, remain_depth - 1, capacity);
    }
    else
        p->right_child->left_child = p->right_child->right_child = NULL;
}

struct cluster
{
    bool center_change;
    double drift;

    double num;
    std::vector<double> sum;
    std::vector<double> center;

    void update();
    void simple_update();

    cluster();
    ~cluster();
};

void cluster::update()
{
    std::vector<double> new_center(center.size());
    for (int i = 0; i < sum.size(); ++i)
    {
        if (num != 0)
            new_center[i] = sum[i] / num;
        if (num == 0)
            new_center[i] = 0.0;
    }

    drift = calculate_distance_norm_2(new_center, center);
    center = new_center;
}
void cluster::simple_update()
{
    for (int i = 0; i < sum.size(); ++i)
    {
        if (num != 0)
            center[i] = sum[i] / num;
        if (num == 0)
            center[i] = 0.0;
    }
}

cluster::cluster()
{
    num = 0;
    center_change = false;
    sum.resize(data[0].size());
    center.resize(data[0].size());
}
cluster::~cluster()
{
}

void store_result(const std::string &path, const std::vector<cluster> &cluster_s)
{
    std::ofstream file_out(path);
    if (!file_out.is_open())
    {
        std::cout << "file open failure";
        throw;
    }
    for (const auto &it : cluster_s)
    {
        for (const auto &it_1 : it.center)
            file_out << it_1 << ' ';
        file_out << '\n';
    }
    file_out.close();
}

void same_size_kmeans(std::vector<cluster> &cluster_s, std::vector<std::vector<int>> &group)
{
    std::vector<int> belong(cluster_s.size());
    for (int i = 0; i < group.size(); ++i)
        for (const auto &it_1 : group[i])
            belong[it_1] = i;

    bool any_adjust = true;
    for (; any_adjust;)
    {
        any_adjust = false;

        std::vector<std::vector<double>> mean(group.size());
        std::vector<int> belong_num(group.size()); //record every group have num
        for (auto &it_1 : belong_num)
            it_1 = 0;
        for (auto &it_1 : mean)
            it_1.resize(data[0].size());
        for (auto &it_1 : mean)
            for (auto &it_2 : it_1)
                it_2 = 0.0;
        for (int j = 0; j < cluster_s.size(); ++j)
        {
            vector_a_add_b(mean[belong[j]], cluster_s[j].center);
            ++belong_num[belong[j]];
        }
        for (int j = 0; j < mean.size(); ++j)
            for (auto &it_2 : mean[j])
                it_2 /= belong_num[j];

        std::vector<std::vector<double>> cluster_mean_distance(cluster_s.size());
        std::vector<bool> belong_adjust(cluster_s.size());
        for (auto &it_1 : cluster_mean_distance)
            it_1.resize(group.size());
        for (int j = 0; j < cluster_s.size(); ++j)
        {
            int min_pos = 0;
            double min = std::numeric_limits<double>::max();
            for (int k = 0; k < group.size(); ++k)
            {
                double temp = cluster_mean_distance[j][k] = calculate_square(cluster_s[j].center, mean[k]);
                if (temp < min)
                {
                    min = temp;
                    min_pos = k;
                }

                if (min_pos == belong[j])
                    belong_adjust[j] = false;
                else
                    belong_adjust[j] = true;
            }
        }

        for (int j = 0; j < cluster_s.size() - 1; ++j)
            if (belong_adjust[j])
                for (int k = j + 1; k < cluster_s.size(); ++k)
                    if ((cluster_mean_distance[j][belong[j]] + cluster_mean_distance[k][belong[k]]) > (cluster_mean_distance[j][belong[k]] + cluster_mean_distance[k][belong[j]]))
                    {
                        std::swap(belong[j], belong[k]);

                        any_adjust = true;
                    }
    }

    for (auto &it : group) //update group
        it.clear();
    for (int i = 0; i < belong.size(); ++i)
        group[belong[i]].push_back(i);
}

std::vector<cluster> kmeans_algorithm(const std::vector<bool> &choose, const int k_num, const int iteration_times)
{
    const bool ball = choose[0];
    const bool Hame = choose[1];
    const bool Yingyang = choose[2];
    const bool regroup = choose[3];//regroup方法，暂时有问题未解决，考虑到和另外几个算法差异性，还没确定放不放到硬件来做

    const bool simple_method = !choose[0] & !choose[1] & !choose[2] & !choose[3];

    /* random initialize center */
    std::vector<cluster> cluster_s(k_num);
    for (int i = 0; i < k_num; ++i)
    {
        //int pos = data.size() % rand() - 1;
        cluster_s[i].center = data[i]; //在对比中，让两种方法拥有同样的初始化中心
    }

    /* divide group*/
    std::vector<double> up_bound(data.size());
    std::vector<double> global_low_bound(data.size());
    std::vector<int> belong(data.size());

    std::list<ball_node *> list_ball;
    std::vector<int> vec_point;
    ball_tree ball_a(log2(data.size()), 30);
    if (ball)
    {
        ball_node *p = ball_a.root;
        list_ball.push_back(p);

        double min_0 = std::numeric_limits<double>::max();
        double min_1 = std::numeric_limits<double>::max();
        for (int i = 0; i < k_num; ++i)
        {
            double temp = calculate_distance_norm_2(p->pivot, cluster_s[i].center);
            if (min_0 > temp)
            {
                std::swap(min_0, temp);
                p->belong = i;
            }
            if (min_1 > temp)
                min_1 = temp;
        }
        p->up_bound = min_0;
        p->global_low_bound = min_1;

        cluster_s[p->belong].num = p->num;
        cluster_s[p->belong].sum = p->sum;

        for (auto &it : cluster_s)
            it.drift = 0.0;
    }
    else
    {
        for (int i = 0; i < data.size(); ++i)
            vec_point.push_back(i);

        cluster_s[0].num = data.size();
        for (int i = 0; i < data.size(); ++i)
            vector_a_add_b(cluster_s[0].sum, data[i]);
    }

    std::vector<std::vector<int>> group;
    std::vector<std::vector<double>> group_low_bound;
    std::vector<double> group_max_drift;
    const int group_capacity = 10;
    if (Yingyang)
    {
        group.resize(k_num / group_capacity);
        for (int i = 0; i < group.size() - 1; ++i)
        {
            group[i].resize(group_capacity);
            for (int j = 0; j < group[i].size(); ++j)
                group[i][j] = i * group_capacity + j;
        }
        group[group.size() - 1].resize(k_num % group_capacity + group_capacity);
        for (int i = 0; i < group[group.size() - 1].size(); ++i)
            group[group.size() - 1][i] = (group.size() - 1) * group_capacity + i;

        group_low_bound.resize(data.size());
        for (auto &it : group_low_bound)
        {
            it.resize(group.size());
            for (auto &it_1 : it)
                it_1 = 0.0;
        }
        if (ball)
        {
            list_ball.front()->group_low_bound.resize(group.size());
            for (auto &it : list_ball.front()->group_low_bound)
                it = 0.0;
        }

        group_max_drift.resize(group.size());
        for (auto &it : group_max_drift)
            it = 0.0;
    }
    double max_drift = 0.0;
    int max_drift_pos = 0;
    double max_drift_1 = 0.0;
    std::vector<double> nearst_center_distance(k_num, 0.0);

    /* 交给硬件来做 */
    if (!simple_method)
    {
        for (int i = 0; i < iteration_times; ++i)
        {

            bool center_change = false;
            for (auto &it : cluster_s)
                it.center_change = false;

            int star = clock();
            if (Yingyang)
            {
                for (auto &it : list_ball)
                    for (int k = 0; k < group.size(); ++k)
                        it->group_low_bound[k] -= group_max_drift[k];

                for (int j = 0; j < data.size(); ++j)
                    for (int k = 0; k < group.size(); ++k)
                        group_low_bound[j][k] -= group_max_drift[k];
            }

            for (auto &it_1 : list_ball)
            {
                it_1->up_bound += cluster_s[it_1->belong].drift;
                if (it_1->belong == max_drift_pos)
                    it_1->global_low_bound -= max_drift_1;
                else
                    it_1->global_low_bound -= max_drift;
            }
            for (auto &it_1 : vec_point)
            {
                up_bound[it_1] += cluster_s[belong[it_1]].drift;
                if (belong[it_1] == max_drift_pos)
                    global_low_bound[it_1] -= max_drift_1;
                else
                    global_low_bound[it_1] -= max_drift;
            }

           /*  if (iteration_times % 10 == 0 && regroup)
                same_size_kmeans(cluster_s, group); */ //regroup方法，暂时有问题未解决，考虑到和另外几个算法差异性，还没确定放不放到硬件来做
            for (auto it = list_ball.begin(); it != list_ball.end();)
            {

                ball_node *object = *it;

                if (nearst_center_distance[object->belong] > object->global_low_bound)
                    object->global_low_bound = nearst_center_distance[object->belong];

                if (object->up_bound + 2 * object->raidus > object->global_low_bound)
                {
                    object->up_bound = calculate_distance_norm_2(object->pivot, cluster_s[object->belong].center);

                    if (object->up_bound + 2 * object->raidus > object->global_low_bound)
                    {
                        if (!Yingyang)
                        {
                            double min_0 = std::numeric_limits<double>::max();
                            double min_1 = std::numeric_limits<double>::max();
                            int new_belong = 0;
                            for (int k = 0; k < k_num; ++k)
                            {
                                double temp = calculate_distance_norm_2(object->pivot, cluster_s[k].center);
                                if (min_0 > temp)
                                {
                                    std::swap(min_0, temp);

                                    new_belong = k;
                                }
                                if (min_1 > temp)
                                    min_1 = temp;
                            }
                            if (new_belong != object->belong) //这一步要等
                            {
                                center_change = true;
                                cluster_s[new_belong].center_change = true;
                                cluster_s[object->belong].center_change = true;

                                object->up_bound = min_0;
                                object->global_low_bound = min_1;

                                cluster_s[object->belong].num -= object->num;
                                vector_a_sub_b(cluster_s[object->belong].sum, object->sum);

                                object->belong = new_belong;
                                cluster_s[object->belong].num += object->num;
                                vector_a_add_b(cluster_s[object->belong].sum, object->sum);
                            }
                        }
                        else
                        {

                            std::vector<int> group_active_num;

                            for (int k = 0; k < object->group_low_bound.size(); ++k)
                                if (object->up_bound + 2 * object->raidus > object->group_low_bound[k])
                                    group_active_num.push_back(k);

                            double min_0 = std::numeric_limits<double>::max();
                            double min_1 = std::numeric_limits<double>::max();
                            int new_belong = 0;
                            for (auto &it_2 : group_active_num)
                            {
                                double cur_group_min = std::numeric_limits<double>::max();
                                for (auto &it_3 : group[it_2])
                                {

                                    double temp = calculate_distance_norm_2(object->pivot, cluster_s[it_3].center);
                                    if (cur_group_min > temp)
                                        cur_group_min = temp;
                                    if (min_0 > temp)
                                    {
                                        std::swap(min_0, temp);

                                        new_belong = it_3;
                                    }
                                    if (min_1 > temp)
                                        min_1 = temp;
                                }
                                object->group_low_bound[it_2] = cur_group_min;
                            }
                            if (!group_active_num.empty() && min_0 < object->up_bound)
                            {
                                center_change = true;
                                cluster_s[new_belong].center_change = true;
                                cluster_s[object->belong].center_change = true;

                                for (auto &it_2 : object->group_low_bound) //没有激活的组可能有第二小的元素
                                    if (min_0 < it_2 && it_2 < min_1)
                                        min_1 = it_2;

                                object->up_bound = min_0;
                                object->global_low_bound = min_1;

                                cluster_s[object->belong].num -= object->num;
                                vector_a_sub_b(cluster_s[object->belong].sum, object->sum);

                                object->belong = new_belong;
                                cluster_s[object->belong].num += object->num;
                                vector_a_add_b(cluster_s[object->belong].sum, object->sum);
                            }
                        }

                        if (object->up_bound + 2 * object->raidus > object->global_low_bound) //节点可能不能整个分配出去
                        {
                            if (object->point_list.empty())
                            {
                                object->left_child->belong = object->right_child->belong = object->belong;

                                object->left_child->up_bound = object->up_bound + object->left_child->distance_to_parent; //equation 12
                                object->left_child->global_low_bound = object->global_low_bound - object->left_child->distance_to_parent;
                                object->right_child->up_bound = object->up_bound + object->right_child->distance_to_parent;
                                object->right_child->global_low_bound = object->global_low_bound - object->right_child->distance_to_parent;

                                if (Yingyang) //equation 12
                                {
                                    object->left_child->group_low_bound.resize(object->group_low_bound.size());
                                    for (int k = 0; k < object->group_low_bound.size(); ++k)
                                        object->left_child->group_low_bound[k] = object->group_low_bound[k] - object->left_child->distance_to_parent;
                                    object->right_child->group_low_bound.resize(object->group_low_bound.size());
                                    for (int k = 0; k < object->group_low_bound.size(); ++k)
                                        object->right_child->group_low_bound[k] = object->group_low_bound[k] - object->right_child->distance_to_parent;
                                }

                                list_ball.push_back(object->left_child);
                                list_ball.push_back(object->right_child);
                            }
                            else
                            {
                                for (auto &it_2 : object->point_list)
                                {

                                    belong[it_2] = object->belong;
                                    up_bound[it_2] = object->up_bound + calculate_distance_norm_2(data[it_2], object->pivot);
                                    global_low_bound[it_2] = object->global_low_bound - calculate_distance_norm_2(data[it_2], object->pivot);

                                    if (Yingyang)
                                        for (int w = 0; w < group.size(); ++w)
                                            group_low_bound[it_2][w] = object->group_low_bound[w] - calculate_distance_norm_2(data[it_2], object->pivot);

                                    vec_point.push_back(it_2);
                                }
                            }

                            it = list_ball.erase(it);
                        }
                        else
                            ++it;
                    }
                    else
                        ++it;
                }
                else
                    ++it;
            }

            for (auto &it_2 : vec_point)
            {
                if (nearst_center_distance[belong[it_2]] > global_low_bound[it_2])
                    global_low_bound[it_2] = nearst_center_distance[belong[it_2]];

                if (up_bound[it_2] < global_low_bound[it_2])
                    continue;

                up_bound[it_2] = calculate_distance_norm_2(data[it_2], cluster_s[belong[it_2]].center);
                if (up_bound[it_2] < global_low_bound[it_2])
                    continue;

                if (Yingyang)
                {

                    std::vector<int> group_active_num;
                    for (int k = 0; k < group_low_bound[it_2].size(); ++k)
                        if (up_bound[it_2] > group_low_bound[it_2][k]) //有可能点不动
                            group_active_num.push_back(k);

                    double min_0 = std::numeric_limits<double>::max();
                    double min_1 = std::numeric_limits<double>::max();
                    int new_belong = 0;
                    for (auto &it_3 : group_active_num)
                    {
                        double cur_group_min = std::numeric_limits<double>::max();
                        for (auto &it_4 : group[it_3])
                        {
                            double temp = calculate_distance_norm_2(data[it_2], cluster_s[it_4].center);
                            if (cur_group_min > temp)
                                cur_group_min = temp;

                            if (min_0 > temp)
                            {
                                std::swap(min_0, temp);

                                new_belong = it_4;
                            }
                            if (min_1 > temp)
                                min_1 = temp;
                        }
                        group_low_bound[it_2][it_3] = cur_group_min;
                    }
                    if (group_active_num.empty() || up_bound[it_2] < min_0) //有可能点不动，而由于计算误差当前组的下界略微比上界更大
                        new_belong = belong[it_2];
                    else
                    {
                        center_change = true;
                        cluster_s[belong[it_2]].center_change = true;
                        cluster_s[new_belong].center_change = true;

                        for (auto &it_3 : group_low_bound[it_2]) //没有激活的组可能有第二小的元素
                            if (min_0 < it_3 && it_3 < min_1)
                                min_1 = it_3;
                        up_bound[it_2] = min_0;
                        global_low_bound[it_2] = min_1;

                        cluster_s[belong[it_2]].num -= 1;
                        vector_a_sub_b(cluster_s[belong[it_2]].sum, data[it_2]);

                        belong[it_2] = new_belong;
                        cluster_s[belong[it_2]].num += 1;
                        vector_a_add_b(cluster_s[belong[it_2]].sum, data[it_2]);
                    }
                }
                else
                {
                    double min_0 = std::numeric_limits<double>::max();
                    double min_1 = std::numeric_limits<double>::max();
                    int new_belong = 0;
                    for (int i = 0; i < k_num; ++i)
                    {
                        double temp = calculate_distance_norm_2(data[it_2], cluster_s[i].center);
                        if (min_0 > temp)
                        {
                            std::swap(min_0, temp);

                            new_belong = i;
                        }
                        if (min_1 > temp)
                            min_1 = temp;
                    }
                    if (belong[it_2] != new_belong)
                    {
                        center_change = true;
                        cluster_s[belong[it_2]].center_change = true;
                        cluster_s[new_belong].center_change = true;

                        up_bound[it_2] = min_0;
                        global_low_bound[it_2] = min_1;

                        cluster_s[belong[it_2]].num -= 1;
                        vector_a_sub_b(cluster_s[belong[it_2]].sum, data[it_2]);

                        belong[it_2] = new_belong;
                        cluster_s[belong[it_2]].num += 1;
                        vector_a_add_b(cluster_s[belong[it_2]].sum, data[it_2]);
                    }
                }
            }

            if (!center_change)
                break;
            for (auto &it_1 : cluster_s)
            {
                if (it_1.center_change)
                    it_1.update();
            }

            if (Yingyang)
                for (int j = 0; j < group.size(); ++j)
                {
                    group_max_drift[j] = 0.0;
                    for (auto &it_2 : group[j])
                        if (cluster_s[it_2].drift > group_max_drift[j])
                            group_max_drift[j] = cluster_s[it_2].drift;
                }

            for (int j = 0; j < k_num; ++j)
            {
                nearst_center_distance[j] = std::numeric_limits<double>::max();
                for (int k = 0; k < k_num; ++k)
                {
                    double temp = calculate_distance_norm_2(cluster_s[j].center, cluster_s[k].center);
                    if (nearst_center_distance[j] > temp)
                        nearst_center_distance[j] = temp;
                }
            }

            max_drift_pos = 0;
            max_drift = 0.0;
            max_drift_1 = 0.0;
            for (int j = 0; j < k_num; ++j)
            {
                double temp = cluster_s[j].drift;
                if (max_drift < temp)
                {
                    std::swap(max_drift, temp);
                    max_drift_pos = j;
                }
                if (max_drift_1 < temp)
                    max_drift_1 = temp;
            }

            std::cout << "times " << i << '\n';
            std::cout << "cost time : " << clock() - star << '\n';
        }

        const std::string path = "D:\\experience\\g++_c++\\unik\\unik_result.txt";
        store_result(path, cluster_s);
    }

    else
    {
        for (int i = 0; i < iteration_times; ++i)
        {
            int star = clock();
            for (auto &it_2 : vec_point)
            {

                double min_0 = std::numeric_limits<double>::max();
                int new_belong = 0;
                for (int i = 0; i < k_num; ++i)
                {
                    double temp = calculate_distance_norm_2(data[it_2], cluster_s[i].center);
                    if (min_0 > temp)
                    {
                        min_0 = temp;
                        new_belong = i;
                    }
                }
                if (belong[it_2] != new_belong)
                {
                    cluster_s[belong[it_2]].num -= 1;
                    vector_a_sub_b(cluster_s[belong[it_2]].sum, data[it_2]);

                    belong[it_2] = new_belong;
                    cluster_s[belong[it_2]].num += 1;
                    vector_a_add_b(cluster_s[belong[it_2]].sum, data[it_2]);
                }
            }
            for (auto &it_1 : cluster_s)
                it_1.simple_update();

            std::cout << "times " << i << '\n';
            std::cout << "cost time : " << clock() - star << '\n';
        }

        const std::string path = "D:\\experience\\g++_c++\\unik\\simple_method_result.txt";
        store_result(path, cluster_s);
    }
    return cluster_s;
}

int main()
{
    const std::string path = "D:\\experience\\g++_c++\\unik\\europediff_169300_2.txt";
    const int training_num = 169300;
    const int dimension = 2;
    /*  const std::string path = "D:\\experience\\g++_c++\\unik\\RelationNetworkDirected.txt";
    const int training_num = 53413;
    const int dimension = 24;
    load_data(path, training_num, dimension);
    */
    /* const std::string path = "D:\\experience\\g++_c++\\unik\\mnist.txt";
    const int training_num = 60000;
    const int dimension = 784; */
    load_data(path, training_num, dimension);
    const int k_num = 1024;
    const int iteration_times = 100;
    const std::vector<bool> choose{true, true, true, true}; //0->ball_tree,1->Hame,2->Yingyang,3->regroup
    std::vector<cluster> clu_test = kmeans_algorithm(choose, k_num, iteration_times);

    const std::vector<bool> choose_1{false, false, false, false}; //0->ball_tree,1->Hame,2->Yingyang,3->regroup
    std::vector<cluster> clu_simple_method = kmeans_algorithm(choose_1, k_num, iteration_times);

    system("pause");
}