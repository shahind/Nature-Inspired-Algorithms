import os
from flask import Flask, render_template, request, redirect, url_for, jsonify
from Main import Main
from Graph import Graph

app = Flask(__name__)

app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'abo-vrp-anya')


###
# Routing for your application.
###

@app.route('/')
def home():
    """Render website's home page."""
    return render_template('home.html')

@app.route('/api/results')
def results():
    with app.app_context():
        data = []
        main = Main()
        try:
            buffalo_size = int(request.args.get('buffalo_size'))
            main.generateResults(0, [0.6, 0.5], 0.9, buffalo_size, 50, 3, 3000)
        except ValueError:
            main.generateResults()
        for res in main.results:
            data.append({
                'buffalo_no':res['buffalo_no'],
                'total_demands':res['total_demands'],
                'routes':res['real_nodes'],
                'graph':{
                    'name':res['graph'].getLocationNames(),
                    'coor':res['graph'].getLongLat(),
                    'node':res['graph'].getNodes(),
                    'demands':res['graph'].getDemands()
                },
                'cost':res['buffalo'].getTotalDistance()
            })
        response = jsonify(data)
        return response

@app.route('/api/results/<int:depot_index>/<float:lp1>/<float:lp2>/<float:speed>/<int:buffalo_size>/<int:trial_size>/<int:bg_not_updating>/<int:max_demands>', methods=['GET','POST'])
def customResults(depot_index, lp1, lp2, speed, buffalo_size, trial_size, bg_not_updating, max_demands):
    with app.app_context():
        data = []
        main = Main()
        results = main.generateResults(depot_index, [lp1, lp2], speed, buffalo_size, trial_size, bg_not_updating, max_demands)
        if results is None:
            return jsonify(message='Error Happens'), 500

        if results['status'] is False:
            return jsonify(message=results['message']), 500

        for res in results['data']:
            data.append({
                'buffalo_no':res['buffalo_no'],
                'total_demands':res['total_demands'],
                'routes':res['real_nodes'],
                'graph':{
                    'name':res['graph'].getLocationNames(),
                    'coor':res['graph'].getLongLat(),
                    'node':res['graph'].getNodes(),
                    'demands':res['graph'].getDemands()
                },
                'cost':res['buffalo'].getTotalDistance()
            })
        response = jsonify(data)
        return response

@app.route('/api/nodes')
def getNodes():
    with app.app_context():
        graph = Graph()
        size = len(graph.getLocationNames())
        data = []
        for i in xrange(size):
            data.append({
                'name':graph.getLocationNames()[i],
                'coor':graph.getLongLat()[i],
                'node':graph.getNodes()[i],
                'demands':graph.getDemands()[i],
                'distances': graph.getDistance()[i]
            })
        return jsonify(data)


###
# The functions below should be applicable to all Flask apps.
###

@app.route('/<file_name>.txt')
def send_text_file(file_name):
    """Send your static text file."""
    file_dot_text = file_name + '.txt'
    return app.send_static_file(file_dot_text)


@app.after_request
def add_header(response):
    """
    Add headers to both force latest IE rendering engine or Chrome Frame,
    and also to cache the rendered page for 10 minutes.
    """
    response.headers['X-UA-Compatible'] = 'IE=Edge,chrome=1'
    response.headers['Cache-Control'] = 'public, max-age=600'
    return response


@app.errorhandler(404)
def page_not_found(error):
    """Custom 404 page."""
    return render_template('404.html'), 404


if __name__ == '__main__':
    app.run(debug=True)
